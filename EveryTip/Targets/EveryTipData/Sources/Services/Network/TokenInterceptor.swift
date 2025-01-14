//
//  TokenInterceptor.swift
//  EveryTipData
//
//  Created by 김경록 on 11/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain
import EveryTipCore

import Alamofire

final class TokenInterceptor: RequestInterceptor {
        
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard let aceessToken = TokenKeyChainManager.shared.getToken(type:  .access) else {
            completion(.success(urlRequest))
            return
        }
    
        // TODO: 추후 API가 토큰을 어떤 형식으로 받는지 체크 후 수정 필요
        var request = urlRequest
        request.addValue(aceessToken, forHTTPHeaderField: "Authorization")
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        // 401 인증 오류가 아니면 재시도하지 않음
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            print("리트라이에서 401이 아니라서 리트라이 진행하지 않음")
            completion(.doNotRetry)
            return
        }
        //401에러가 발생한 경우 리트라이 진행
        
        //TODO: API부재로 의사 코드 작성, 추후 수정 필요
        // let code = renewAccessToken(_ aceessToken: "").statusCode
        
        let code = 201
        
        if code == 200 {
            //새로 받은 accessToken이 저장되었다.
            completion(.retryWithDelay(1))
        } else {
            //리프레쉬 토큰마저 만료되었다는 서버의 응답을 받았다
            let tokenManager = TokenKeyChainManager.shared
            tokenManager.deleteToken(type: .access)
            tokenManager.deleteToken(type: .refresh)
            
            completion(.doNotRetryWithError(error))
        }
    }
}
