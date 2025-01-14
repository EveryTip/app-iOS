//
//  TokenUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol RequestTokenUseCase {
    func excute(email: String, password: String) -> Single<TokenResponse>
}

final public class DefaultRequestTokenUseCase: RequestTokenUseCase {
    private let loginRepository: UserLoginRepository
    
    init(loginRepository: UserLoginRepository) {
        self.loginRepository = loginRepository
    }
    
    public func excute(email: String, password: String) -> Single<TokenResponse> {
        return loginRepository.login(with: email, password: password)
    }
}
