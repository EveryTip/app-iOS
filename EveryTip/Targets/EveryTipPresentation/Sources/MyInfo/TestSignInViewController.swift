//
//  TestSignInViewController.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/25/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit


// MARK: - Text Field 테스트

class TestSignInViewController: BaseViewController, View {
    
    var disposeBag: DisposeBag = .init()
    
    let nameTextFieldView: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true)
        view.textField.placeholder = "입력값 매번 검사, 상태 변환"
        view.textField.tintColor = .purple
        view.borderColorWhenNormal = .brown
        view.borderColorWhenEditing = .black
        view.borderColorWhenSuccess = .blue
        view.borderColorWhenError = .red
        return view
    }()
    
    let emailTextFieldView: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true, textFieldRightInset: 80)
        view.textField.placeholder = "text field right inset 70"
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        return button
    }()
    
    let insetTestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("inset test", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 14
        )
        button.setTitleColor(.et_brandColor2, for: .normal)
        button.backgroundColor = .et_brandColor2.withAlphaComponent(0.15)
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = TestSignInReactor()
        let testLabel = UILabel()
        testLabel.font = UIFont.systemFont(ofSize: 18)
        testLabel.text = "TEST"

        view.addSubViews(
            testLabel,
            nameTextFieldView,
            emailTextFieldView,
            insetTestButton,
            loginButton
        )
        
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        nameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(testLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(nameTextFieldView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        insetTestButton.snp.makeConstraints {
            $0.right.equalTo(emailTextFieldView.snp.right).inset(5)
            $0.centerY.equalTo(emailTextFieldView.borderView)
            $0.width.equalTo(70)
            $0.height.equalTo(36)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(60)
        }
        
        // text field text 인풋 시, 이전값과 입력값 비교하여 공백이 없고 최대 길이를 유지하도록 함
        nameTextFieldView.textField.rx.text
            .orEmpty
            .scan(nameTextFieldView.textField.text) { prevText, newText -> String? in
                guard newText.count == newText.trimmingCharacters(in: .whitespacesAndNewlines).count
                else { return prevText }
                let maxLength = 6
                guard newText.count <= maxLength else { return prevText }
                return newText
            }.bind(to: nameTextFieldView.textField.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: 입력 시 마다 상태 업데이트
        // text field 의 입력 시 상태 처리와 메시지 표시
        nameTextFieldView.action
            .bind { [weak self] action in
                switch action {
                case .editingDidBegin:
                    self?.nameTextFieldView.status.onNext(.editing)
                    
                // 입력값 매번 검사 & 상태 전환
                case .editingDidEnd, .editingDidEndOnExit, .textChanged:
                    let text = self?.nameTextFieldView.textField.text ?? ""
                    if text.isEmpty {
                        self?.nameTextFieldView.status.onNext(.normal)
                        print("text is empty")
                        return
                    }
                    let minLength = 2
                    guard text.count >= minLength else {
                        let errorMessage = "최소 2자 이상 입력"
                        self?.nameTextFieldView.guideMessageLabel.text = errorMessage
                        self?.nameTextFieldView.status.onNext(.error)
                        return
                    }
                    let successMessage = "성궁"
                    self?.nameTextFieldView.guideMessageLabel.text = successMessage
                    self?.nameTextFieldView.status.onNext(.success)
                }
            }.disposed(by: disposeBag)
        
        // text field text 인풋 시, 이전값과 입력값 비교하여 공백이 없고 최대 길이를 유지하도록 함
        emailTextFieldView.textField.rx.text
            .orEmpty
            .scan(emailTextFieldView.textField.text) { prevText, newText -> String? in
                guard newText.count == newText.trimmingCharacters(in: .whitespacesAndNewlines).count
                else { return prevText }
                let maxLength = 30
                guard newText.count <= maxLength else { return prevText }
                return newText
            }.bind(to: emailTextFieldView.textField.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: 입력 종료 시에만 상태 업데이트
        emailTextFieldView.action
            .bind { [weak self] action in
                switch action {
                // 입력 중일 시 상태 확인 안함
                case .editingDidBegin, .textChanged:
                    self?.emailTextFieldView.status.onNext(.editing)
                    
                // 입력 종료 시 상태 업데이트
                case .editingDidEnd, .editingDidEndOnExit:
                    let text = self?.emailTextFieldView.textField.text ?? ""
                    if text.isEmpty {
                        self?.emailTextFieldView.status.onNext(.normal)
                        print("text is empty")
                        return
                    }
                    let minLength = 10
                    guard text.count >= minLength else {
                        let errorMessage = "최소 10자 이상 입력"
                        self?.emailTextFieldView.guideMessageLabel.text = errorMessage
                        self?.emailTextFieldView.status.onNext(.error)
                        return
                    }
                    // 성공 시 메시지 없음
                    self?.emailTextFieldView.guideMessageLabel.text = nil
                    self?.emailTextFieldView.status.onNext(.success)
                }
            }.disposed(by: disposeBag)
    }
    
    func bind(reactor: TestSignInReactor) {
        reactor.state.map { $0.resultMessage }
            .compactMap { $0 }
            .bind { [weak self] in
                self?.showAlert(titile: "로그인 결과", message: $0)
            }.disposed(by: disposeBag)
        
        loginButton.rx.tap
            .withLatestFrom(nameTextFieldView.textField.rx.text)
            .compactMap { $0 }
            .map { Reactor.Action.didTapLoginButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        insetTestButton.rx.tap
            .bind { [weak self] _ in
                let toggled = self?.emailTextFieldView.isEnabled ?? true ? false : true
                // not enabled 처리 유의
                self?.emailTextFieldView.isEnabled = toggled
                if !toggled {
                    self?.emailTextFieldView.status.onNext(.notEnabled)
                    self?.emailTextFieldView.textField.text = nil
                }
            }.disposed(by: disposeBag)
    }
    
    func showAlert(titile : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Text Field 테스트 reactor

final class TestSignInReactor: Reactor {
    typealias EmailText = String
    enum Action {
        case didTapLoginButton(EmailText)
    }
    
    enum Mutation {
        case login(Bool)
    }
    
    struct State {
        var resultMessage: String?
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLoginButton(let email):
            print("try login \(email)")
            return Observable.just(Mutation.login(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .login(let result):
            newState.resultMessage = result ? "로그인 성공" : "로그인 실패"
        }
        
        return newState
    }
}
