//
//  DefaultUserLoginRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 10/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

final class DefaultUserLoginRepository: UserLoginRepository {
    func login(with email: String, password: String) -> Single<TokenResponse> {
        return Single.create { single in
            do {
                let request = try AuthTarget.postUserLogin(email: email, password: password).asURLRequest()
                
                AF.request(request, interceptor: nil)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: TokenResponse.self) { response in
                        switch response.result {
                        case .success(let token):
                            single(.success(token))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
