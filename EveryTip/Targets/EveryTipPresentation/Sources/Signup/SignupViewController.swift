//
//  SignupViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem
import EveryTipDomain

import SnapKit
import RxSwift
import ReactorKit

final class SignUpViewController: BaseViewController {
    
    weak var coordinator: SignupCoordinator?
    
    var disposeBag = DisposeBag()

    private let titleView: TitleDescriptionView = {
        let view = TitleDescriptionView(
            title: "회원가입",
            subTitle: "회원 여부 확인 및 가입을 진행합니다"
        )
                
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디(이메일)"
        label.font = .et_pretendard(style: .medium, size: 16)
        
        return label
    }()
    
    private let emailTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            textFieldRightInset: 90
        )
        
        etView.textField.placeholder = "예) everytip@everytip.com"
        etView.textField.keyboardType = .emailAddress
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .et_pretendard(
            style: .bold,
            size: 14
        )
        button.tintColor = .et_brandColor2
        button.backgroundColor = .et_brandColor2.withAlphaComponent(0.15)
        button.layer.cornerRadius = 6
        button.setTitle("인증하기", for: .normal)
        
        return button
    }()
    
    private let verificationCodeTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: false,
            textFieldRightInset: 90
        )
        etView.textField.keyboardType = .numberPad
        etView.textField.placeholder = "인증번호 4자리 입력"
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .et_brandColor2
        label.isHidden = true
        
        return label
    }()
    
    private let verificationCompletedLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .et_textColor5
        label.textColor = .et_lineGray20
        label.text = "✓ 인증완료"
        label.font = .et_pretendard(
            style: .bold,
            size: 14
        )
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private let separator: StraightLineView = {
        let line = StraightLineView(color: .et_lineGray20)
        
        return line
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private let passwordTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            hasSecureTextButton: true,
            textFieldRightInset: 16
        )
        
        etView.textField.placeholder = "비밀번호 입력 (영문+숫자 조합 8자리 이상)"
        etView.textField.keyboardType = .asciiCapable
        etView.textField.autocapitalizationType = .none
        return etView
    }()
    
    private let confirmPasswordTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            hasSecureTextButton: true,
            textFieldRightInset: 16
        )
        etView.textField.placeholder = "비밀번호 확인 입력"
        etView.textField.keyboardType = .asciiCapable
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .et_textColor5
        button.tintColor = .white
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 18)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    init(reactor: SignUpReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        
        // TODO: 커스텀 네비게이션으로 대체
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleView,
            emailLabel,
            emailTextFieldView,
            verificationCodeTextFieldView,
            timerLabel,
            separator,
            passwordLabel,
            passwordTextFieldView,
            confirmPasswordTextFieldView,
            submitButton,
            verificationCompletedLabel
        )
        view.addSubview(verifyButton)
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        verifyButton.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(36)
            $0.centerY.equalTo(emailTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(emailTextFieldView.snp.trailing).offset(-8)
        }
        
        verificationCodeTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        verificationCompletedLabel.snp.makeConstraints {
            $0.width.equalTo(verificationCodeTextFieldView.textField.snp.width).multipliedBy(0.36)
            $0.height.equalTo(verificationCodeTextFieldView.textField.snp.height).multipliedBy(0.69)
            $0.centerY.equalTo(verificationCodeTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(verificationCodeTextFieldView.snp.trailing).offset(-9)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(verificationCodeTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(verificationCodeTextFieldView.snp.trailing).offset(-26)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(verificationCodeTextFieldView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(8)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        confirmPasswordTextFieldView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension SignUpViewController: View {
    func bind(reactor: SignUpReactor) {
        bindInput(to: reactor)
        bindOutput(to: reactor)
    }
    
    func bindInput(to reactor: SignUpReactor) {
        verifyButton.rx.tap
            .map { [weak self] in
                let emailInput = self?.emailTextFieldView.textField.text ?? ""
                return Reactor.Action.verifyButtonTapped(email: emailInput)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextFieldView.action
            .map { Reactor.Action.textFieldAction(type: .email, action: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        verificationCodeTextFieldView.action
            .map { Reactor.Action.textFieldAction(type: .verificationCode, action: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 최대 4글자로 제한
        verificationCodeTextFieldView.textField.rx.text
            .orEmpty
            .map { String($0.prefix(4)) }
            .bind(to: verificationCodeTextFieldView.textField.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.action
            .map { Reactor.Action.textFieldAction(
                type: .password,
                action: $0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmPasswordTextFieldView.action
            .map { Reactor.Action.textFieldAction(
                type: .confirmPassword,
                action: $0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .map { Reactor.Action.submitButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(to reactor: SignUpReactor) {
        reactor.state.map { $0.remainingTime }
            .bind { [weak self] timerText in
                
                let minutes = timerText / 60
                let seconds = timerText % 60
                let timerString = String(format: "%d:%02d", minutes, seconds)
                
                self?.timerLabel.text = timerString
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isTimerHidden }
            .bind { [weak self] bool in
                self?.timerLabel.isHidden = bool
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.email]?.status }
            .distinctUntilChanged()
            .bind { [weak self] status in
                self?.emailTextFieldView.status.onNext(status)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.email]?.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.emailTextFieldView.guideMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.verificationCode]?.status }
            .distinctUntilChanged()
            .bind { [weak self] status in
                self?.verificationCodeTextFieldView.status.onNext(status)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.verificationCode]?.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.verificationCodeTextFieldView.guideMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.password]?.status }
            .distinctUntilChanged()
            .bind { [weak self] status in
                self?.passwordTextFieldView.status.onNext(status)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.password]?.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.passwordTextFieldView.guideMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.confirmPassword]?.status }
            .distinctUntilChanged()
            .bind { [weak self] status in
                self?.confirmPasswordTextFieldView.status.onNext(status)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.textFieldStatus[.confirmPassword]?.errorMessage }
            .distinctUntilChanged()
            .bind(to: self.confirmPasswordTextFieldView.guideMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isVerificationCompletedLabelHidden }
            .bind(to: verificationCompletedLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSubmitButtonEnabled }
            .distinctUntilChanged()
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map {
            $0.isSubmitButtonEnabled ? .et_brandColor2 : .et_textColor5
        }
        .bind(to: submitButton.rx.backgroundColor )
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.checkEmailButtonState }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .beforeSending:
                    self?.verifyButton.setTitle("인증하기", for: .normal)
                case .afterSent:
                    self?.verifyButton.setTitle("재전송", for: .normal)
                case .afterVerified:
                    self?.verifyButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
