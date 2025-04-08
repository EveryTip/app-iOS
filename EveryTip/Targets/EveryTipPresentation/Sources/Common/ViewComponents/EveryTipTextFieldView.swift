//
//  EveryTipTextFieldView.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

/**
 커스텀 텍스트 필드 상태값
 */
enum EveryTipTextFieldStatus {
    case normal
    case editing
    case success
    case error
    case notEnabled
}

/**
 커스텀 텍스트 필드 방출값
 */
enum EveryTipTextFieldAction {
    case editingDidBegin
    case editingDidEnd
    case editingDidEndOnExit
    case textChanged(text: String)
}

/**
 커스텀 텍스트 필드
 
 - 상태값과 방출값을 rx subject 형식으로 지님
 
 - 생성 시 파라미터로 text field 의 inset 받음 유의
 
 - not enabled 처리 시 user interaction 과 bg color 만을 변경하고 있으며, text field 의 상태와 값 등은 외부에서 다뤄줘야 함.
 */
final class EveryTipTextFieldView: UIView {
    var borderColorWhenNormal = UIColor.et_lineGray40
    var borderColorWhenEditing = UIColor.et_brandColor2
    var borderColorWhenSuccess = UIColor.et_brandColor2
    var borderColorWhenError = UIColor(hex: "e84d65")
    var borderColorWhenNotEnabled = UIColor.et_lineGray40
    
    var isEnabled: Bool = true {
        didSet {
            borderView.isUserInteractionEnabled = isEnabled
            borderView.backgroundColor = isEnabled ? UIColor.white : UIColor.et_lineGray20
        }
    }
    
    var action: PublishSubject<EveryTipTextFieldAction> = .init()
    var status: BehaviorSubject<EveryTipTextFieldStatus> = .init(value: .normal)
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "플레이스 홀더"
        textField.tintColor = .et_brandColor2
        textField.font = .et_pretendard(style: .medium, size: 16)
       return textField
    }()
    
    let guideMessageLabel: UILabel = {
       let label = UILabel()
        label.text = "안내 메시지"
        label.font = .et_pretendard(style: .medium, size: 14)
        return label
    }()
    
    // 내부적으로 guide message 를 감싸 표시 처리 등에 사용
    private let containerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let textFieldRightInset: CGFloat
    
    private let guideMessageView = UIView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: -
    
    init(
        hasClearButton: Bool,
        hasSecureTextButton: Bool = false,
        textFieldRightInset: CGFloat = 16
    ) {
        textField.clearButtonMode = hasClearButton ? .whileEditing : .never
        textField.isSecureTextEntry = hasSecureTextButton
        self.textFieldRightInset = textFieldRightInset
        super.init(frame: .zero)
        setupLayout()
        setupConstraints()
        setupGuideMessagePriority()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setupGuideMessagePriority() {
        guideMessageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        guideMessageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func setupLayout() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubViews(
            borderView.addSubViews(
                textField
            ),
            guideMessageView.addSubViews(
                guideMessageLabel
            )
        )
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        borderView.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.right.equalToSuperview().inset(textFieldRightInset)
        }
        
        guideMessageLabel.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { EveryTipTextFieldAction.textChanged(text: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .map { EveryTipTextFieldAction.editingDidBegin }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map { EveryTipTextFieldAction.editingDidEnd }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEndOnExit)
            .map { EveryTipTextFieldAction.editingDidEndOnExit }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        let statusBinder: Binder<EveryTipTextFieldStatus> = Binder(self) { view, status in
            switch status {
            case .normal:
                view.textField.isEnabled = true
                view.borderView.backgroundColor = .white
                view.borderView.layer.borderColor = view.borderColorWhenNormal.cgColor
                view.setGuideMessageViewIsHiddenWithAnimate(isHidden: true)
                
            case .editing:
                view.textField.isEnabled = true
                view.borderView.backgroundColor = .white
                view.borderView.layer.borderColor = view.borderColorWhenEditing.cgColor
                
            case .success:
                view.textField.isEnabled = true
                view.borderView.backgroundColor = .white
                view.borderView.layer.borderColor = view.borderColorWhenSuccess.cgColor
                view.guideMessageLabel.textColor = view.borderColorWhenSuccess
                let isHidden = view.guideMessageLabel.text == nil
                view.setGuideMessageViewIsHiddenWithAnimate(isHidden: isHidden)
                
            case .error:
                view.textField.isEnabled = true
                view.borderView.backgroundColor = .white
                view.borderView.layer.borderColor = view.borderColorWhenError.cgColor
                view.guideMessageLabel.textColor = view.borderColorWhenError
                view.setGuideMessageViewIsHiddenWithAnimate(isHidden: false)
                
            case .notEnabled:
                view.textField.resignFirstResponder()
                view.textField.isEnabled = false
                view.borderView.backgroundColor = UIColor.et_lineGray20
                view.borderView.layer.borderColor = view.borderColorWhenNotEnabled.cgColor
                view.setGuideMessageViewIsHiddenWithAnimate(isHidden: true)
            }
        }
        
        status
            .bind(to: statusBinder)
            .disposed(by: disposeBag)
    }
    
    // 내부 애니메이션 전용 메서드
    private func setGuideMessageViewIsHiddenWithAnimate(isHidden: Bool) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            animations: {
                self.guideMessageView.isHidden = isHidden
                self.layoutIfNeeded()
            }
        )
    }
}
