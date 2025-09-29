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
        case emailTextChanged(String)
        case passwordTextChanged(String)
        case loginButtonTapped
        case searchPasswordButtonTapped
    }
    
    enum Mutation {
        case setEmail(String)
        case setPassword(String)
        case setToast(String)
        case setNavigationSignal(Bool)
        case setForgotPasswordSignal(Bool)
    }
    
    struct State {
        var email: String?
        var password: String?
        var guideMessgage: String = ""
        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: Bool = false
        @Pulse var forgotPasswordSignal: Bool = false
    }
    
    let initialState: State
    private var authUseCase: AuthUseCase
    private let tokenManager = TokenKeyChainManager.shared
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginButtonTapped:
            guard let email = currentState.email, !email.isEmpty,
                  let password = currentState.password, !password.isEmpty else {
                return .just(.setToast("이메일과 비밀번호를 모두 입력해주세요"))
            }
            
            if !email.checkRegex(type: .email) {
                return .just(.setToast("이메일 형식을 다시 확인해주세요."))
            }
            
            return authUseCase.login(
                email: email,
                password: password
            )
            .asObservable()
            .flatMap { [weak self] token -> Observable<Mutation> in
                guard let self = self else {
                    return .just(.setToast("알 수 없는 오류가 발생했습니다"))
                }
                let isAccessTokenStored = self.tokenManager.storeToken(
                    token.accessToken,
                    type: .access
                )
                let isRefreshTokenStored = self.tokenManager.storeToken(
                    token.refreshToken,
                    type: .refresh
                )
                
                if isAccessTokenStored && isRefreshTokenStored {
                    return .concat(
                        .just(.setToast("로그인이 완료되었습니다.")),
                        .just(.setNavigationSignal(true))
                    )
                } else {
                    return .just(.setToast("로그인에 실패했습니다."))
                }
            }.catch { error in
                if error.localizedDescription.contains("409") {
                    return .just(.setToast("로그인 정보가 올바르지않습니다."))
                } else {
                    return .just(.setToast("잠시 후 다시 시도해주세요"))
                }
            }
            
        case .emailTextChanged(let email):
            return .just(.setEmail(email))
        case .passwordTextChanged(let password):
            return .just(.setPassword(password))
        case .searchPasswordButtonTapped:
            return .just(.setForgotPasswordSignal(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setToast(let message):
            newState.toastMessage = message
        case .setNavigationSignal(let signal):
            newState.navigationSignal = signal
        case .setEmail(let email):
            newState.email = email
        case .setPassword(let password):
            newState.password = password
        case .setForgotPasswordSignal(let signal):
            newState.forgotPasswordSignal = signal
        }
        
        return newState
    }
}
