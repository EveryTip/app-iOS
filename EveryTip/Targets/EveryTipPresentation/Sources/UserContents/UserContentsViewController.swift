//
//  UserContentsViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipCore

import SnapKit

// TODO: 이 뷰는 아예 미완성임
final class UserContentsViewController: BaseViewController {
    
    weak var coordinator: UserContentsCoordinator?
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원만 쓸 수 있는 버튼", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setupLayout()
        setupConstraints()
        sendMessageButton.addTarget(
            self,
            action: #selector(pushToOnlyUserView),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        view.addSubview(sendMessageButton)
    }
    
    deinit {
        coordinator?.didFinish()
    }
    
    @objc
    private func pushToOnlyUserView() {
        coordinator?.checkLoginBeforeAction(onLoggedIn: { [weak self] in
            self?.coordinator?.pushToOnlyUserView()
        })
    }
    
    private func setupConstraints() {
        sendMessageButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(100)
            $0.height.equalTo(70)
        }
    }
}
