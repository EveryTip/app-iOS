//
//  LoginReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/4/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipCore
import EveryTipDomain

import ReactorKit
import RxSwift

final class LoginReactor: Reactor {
    enum Action {
        case loginButtonTapped(email: String, password: String)
    }
    enum Mutation {
        case setLoginState(Bool)
    }
    struct State {
        var email: String?
        var password: String?
        var isLogined: Bool = false
    }
    
    let initialState: State
    private var loginUseCase: RequestTokenUseCase
    private let tokenManager = TokenKeyChainManager.shared
    
    init(loginUseCase: RequestTokenUseCase) {
        self.loginUseCase = loginUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginButtonTapped(email: let email, password: let password):
            
            return loginUseCase.excute(
                email: email,
                password: password
            )
            .asObservable()
            .flatMap { [weak self] token -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                let isAccessTokenStored = self.tokenManager.storeToken(
                    token.data.accessToken,
                    type: .access
                )
                let isRefreshTokenStored = self.tokenManager.storeToken(
                    token.data.refreshToken,
                    type: .refresh
                )
                
                if isAccessTokenStored && isRefreshTokenStored {
                    return .just(.setLoginState(true))
                } else {
                    print("토큰 저장 실패")
                    return .just(.setLoginState(false))
                }
            }
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            switch mutation {
            case .setLoginState(let isLogined):
                newState.isLogined = isLogined
                
                return newState
            }
        }
    }
}
