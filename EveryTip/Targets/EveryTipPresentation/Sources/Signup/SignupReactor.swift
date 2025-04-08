//
//  SignupReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import ReactorKit
import RxSwift

final class SignUpReactor: Reactor {
    private let timerSubject = BehaviorSubject<Observable<Mutation>>(value: Observable.empty())
    private var timerStream: Observable<Mutation> {
        return timerSubject.switchLatest()
    }
    private let timer = Observable<Int>
        .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
        .map { 300 - $0 }
        .take(while: { $0 >= 0 })
        .map { Mutation.updateTimerState(isHidden: false, remainTime: $0) }
        .do(onDispose: { print("타이머 해제") })
        .share(replay: 1, scope: .whileConnected)
    
    enum VerificationButtonState {
        case beforeSending
        case afterSent
        case afterVerified
    }
    
    enum TextFieldType {
        case email
        case verificationCode
        case password
        case confirmPassword
    }
    
    enum Action {
        case verifyButtonTapped(email: String)
        case textFieldAction(type: TextFieldType, action: EveryTipTextFieldAction)
        case submitButtonTapped
    }
    
    enum Mutation {
        case updateVerifiedLabelVisibility(Bool)
        case updateCheckEmailButtonState(VerificationButtonState)
        case updateTimerState(isHidden: Bool, remainTime: Int)
        case updateTextField(
            type: TextFieldType,
            text: String?,
            status: EveryTipTextFieldStatus,
            errorMessage: String? = nil
        )
        case updateSubmitButtonEnabledState(Bool)
    }
    
    struct State {
        var isVerificationCompletedLabelHidden = true
        var checkEmailButtonState: VerificationButtonState = .beforeSending
        var isSubmitButtonEnabled = false
        var remainingTime = 0
        var isTimerHidden = true
        var textFieldText: [TextFieldType: String] = [:]
        var textFieldStatus: [TextFieldType: (status: EveryTipTextFieldStatus, errorMessage: String?)] = [:]
    }
    
    var initialState: State
    private let authUseCase: AuthUseCase?
    
    init(authUseCase: AuthUseCase) {
        self.initialState = State(
            textFieldStatus: [
                .verificationCode: (.notEnabled, nil),
                .password: (.notEnabled, nil),
                .confirmPassword: (.notEnabled, nil)
            ]
        )
        self.authUseCase = authUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .verifyButtonTapped(let email):
            return handleVerifyButton(email: email)
        case .textFieldAction(let type, let action):
            return handleTextFieldAction(type: type, action: action)
        case .submitButtonTapped:
            return handleSubmit()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateVerifiedLabelVisibility(let hidden):
            newState.isVerificationCompletedLabelHidden = hidden
        case .updateCheckEmailButtonState(let buttonState):
            newState.checkEmailButtonState = buttonState
        case .updateTimerState(let hidden, let time):
            newState.isTimerHidden = hidden
            newState.remainingTime = time
        case .updateTextField(let type, let text, let status, let errorMessage):
            if let textValue = text {
                newState.textFieldText[type] = textValue
            }
            newState.textFieldStatus[type] = (status, errorMessage)
        case .updateSubmitButtonEnabledState(let isEnabled):
            newState.isSubmitButtonEnabled = isEnabled
        }
        return newState
    }
    
    // MARK: - Handlers
    
    private func handleVerifyButton(email: String) -> Observable<Mutation> {
        guard let authUseCase = authUseCase else { return Observable.empty() }
        guard checkRegex(textType: .email, text: email) else {
            return Observable.just(
                .updateTextField(
                    type: .email,
                    text: nil,
                    status: .error,
                    errorMessage: "이메일 형식으로 입력해주세요"
                )
            )
        }
        timerSubject.onNext(timer)
        return authUseCase.requestEmailCode(email: email)
            .andThen(
                Observable.concat([
                    .just(.updateTextField(type: .verificationCode, text: nil, status: .normal)),
                    .just(.updateVerifiedLabelVisibility(true)),
                    .just(.updateCheckEmailButtonState(.afterSent)),
                    timerStream
                ])
            )
            .catch { _ in
                Observable.just(
                    .updateTextField(
                        type: .email,
                        text: nil,
                        status: .error,
                        errorMessage: "이메일을 다시 확인해주세요."
                    )
                )
            }
    }
    
    private func handleTextFieldAction(type: TextFieldType, action: EveryTipTextFieldAction) -> Observable<Mutation> {
        switch action {
        case .textChanged(let text):
            return handleTextChanged(type: type, text: text)
        case .editingDidBegin:
            return Observable.just(.updateTextField(type: type, text: nil, status: .editing))
        case .editingDidEnd:
            if type == .verificationCode {
                return Observable.empty()
            }
            return Observable.just(.updateTextField(type: type, text: nil, status: .normal))
        case .editingDidEndOnExit:
            return Observable.just(.updateTextField(type: type, text: nil, status: .normal))
        }
    }
    
    private func handleTextChanged(type: TextFieldType, text: String) -> Observable<Mutation> {
        switch type {
        case .email:
            return Observable.just(.updateTextField(type: .email, text: text, status: .editing))
        case .verificationCode:
            return handleVerificationCode(text)
        case .password:
            let isValidPassword = checkRegex(textType: .password, text: text)
            return Observable.just(
                .updateTextField(
                    type: .password,
                    text: text,
                    status: isValidPassword ? .editing : .error,
                    errorMessage: isValidPassword ? nil : "영문 + 숫자 조합 8자리 이상 입력해 주세요."
                )
            )
        case .confirmPassword:
            return handleConfirmPassword(text)
        }
    }
    
    private func handleVerificationCode(_ text: String) -> Observable<Mutation> {
        guard let authUseCase = authUseCase else { return Observable.empty() }
        guard checkRegex(textType: .verifyCode, text: text) else {
            return Observable.just(
                .updateTextField(
                    type: .verificationCode,
                    text: text,
                    status: .error,
                    errorMessage: "숫자 4자리만 입력해주세요"
                )
            )
        }
        if text.count == 4 && currentState.remainingTime > 0 {
            return authUseCase.checkEmailCode(code: text)
                .observe(on: MainScheduler.asyncInstance)
                .andThen(
                    Observable.concat([
                        .just(.updateTimerState(isHidden: true, remainTime: 0)),
                        .just(.updateCheckEmailButtonState(.afterVerified)),
                        .just(.updateTextField(type: .email, text: nil, status: .notEnabled)),
                        .just(.updateTextField(type: .verificationCode, text: nil, status: .notEnabled)),
                        .just(.updateTextField(type: .password, text: nil, status: .normal)),
                        .just(.updateTextField(type: .confirmPassword, text: nil, status: .normal)),
                        .just(.updateVerifiedLabelVisibility(false))
                    ])
                )
                .catch { _ in
                    Observable.just(
                        .updateTextField(
                            type: .verificationCode,
                            text: text,
                            status: .error,
                            errorMessage: "인증번호를 다시 확인해주세요"
                        )
                    )
                }
        }
        return Observable.just(.updateTextField(type: .verificationCode, text: text, status: .editing))
    }
    
    private func handleConfirmPassword(_ text: String) -> Observable<Mutation> {
        let passwordText = currentState.textFieldText[.password] ?? ""
        let isMatching = passwordText == text && checkRegex(textType: .password, text: text)
        let status: EveryTipTextFieldStatus = isMatching ? .editing : .error
        let errorMessage = status == .error ? "비밀번호가 일치하지 않습니다." : nil
        let enableSubmit = Observable.just(Mutation.updateSubmitButtonEnabledState(isMatching))
        return Observable.concat([
            .just(
                .updateTextField(
                    type: .confirmPassword,
                    text: text,
                    status: status,
                    errorMessage: errorMessage
                )
            ),
            enableSubmit
        ])
    }
    
    private func handleSubmit() -> Observable<Mutation> {
        // TODO: 이메일 및 비밀번호 데이터 저장 및 다음 화면 넘어가기
        return Observable.empty()
    }
}

// MARK: - Regex Helper
private enum TextType {
    case email
    case password
    case verifyCode
}

private func checkRegex(textType: TextType, text: String?) -> Bool {
    guard let text = text else {
        return false
    }
    switch textType {
    case .email:
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return text.range(of: pattern, options: .regularExpression) != nil
    case .password:
        let pattern = "(?=.*[A-Za-z])(?=.*\\d).{8,}"
        return text.range(of: pattern, options: .regularExpression) != nil
    case .verifyCode:
        return Int(text) != nil
    }
}
