//
//  NicknameReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class NicknameReactor: Reactor {
    enum ValidationResult {
        case none
        case valid
        case empty
        case invalidFormat
        case duplicated

        var message: String? {
            switch self {
            case .none:
                return nil
            case .valid:
                return "사용 가능한 닉네임입니다."
            case .empty:
                return "닉네임을 입력해주세요."
            case .invalidFormat:
                return "닉네임 형식이 옳바르지 않습니다."
            case .duplicated:
                return "이미 사용 중인 닉네임입니다."
            }
        }
    }

    enum Action {
        case textChanged(String)
        case checkDuplication
        case randomButtonTapped
        case confirmButtonTapped
    }

    enum Mutation {
        case setNickname(String)
        case setValidation(ValidationResult)
        case setToast(String)
    }

    struct State {
        var nicknameText: String = ""
        var validationResult: ValidationResult = .none
        @Pulse var toastMessage: String?
    }

    var initialState = State()
    private let userUseCase: UserUseCase

    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textChanged(let text):
            if text.isEmpty {
                return .just(.setValidation(.empty))
            }
        
            return Observable.concat(
                .just(.setNickname(text)),
                .just(.setValidation(.none))
            )
        
        case .checkDuplication:
            let currentText = currentState.nicknameText
            if currentText.isEmpty {
                return .just(.setValidation(.empty))
            } else if !currentText.checkRegex(type: .nickname) {
                return .just(.setValidation(.invalidFormat))
            }
            
            // TODO: 중복검사 useCase 삽입
            return Observable.just(false)
                .asObservable()
                .flatMap { isDuplicated in
                    let result: ValidationResult = isDuplicated ? .duplicated : .valid
                    return Observable.just(Mutation.setValidation(result))
                }

        case .randomButtonTapped:
            return userUseCase.fetchRamdomNickName()
                .asObservable()
                .flatMap { randomNick in
                    Observable.concat([
                        .just(.setNickname(randomNick)),
                        .just(.setValidation(.none))
                    ])
                }

        case .confirmButtonTapped:
            if currentState.validationResult != .valid {
                return .just(.setToast("닉네임 중복 확인을 해주세요."))
            }
            return .just(.setToast("닉네임 설정이 완료되었어요"))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNickname(let updated):
            newState.nicknameText = updated
        case .setValidation(let validation):
            newState.validationResult = validation
        case .setToast(let message):
            newState.toastMessage = message
        }
        return newState
    }
}
