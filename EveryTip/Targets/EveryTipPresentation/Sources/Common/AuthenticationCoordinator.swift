//
//  AuthenticationCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/6/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipCore

import RxSwift

protocol AuthenticationCoordinator: Coordinator {
    func checkLoginBeforeAction(onLoggedIn: @escaping () -> Void)
    func pushToLoginView()
    // TODO: 고민해보고 분리해도 좋을듯
    func presentLoginRequiredAlert()
}

extension AuthenticationCoordinator {
    /// 로그인이 필요한 작업은 해당 메서드를 거쳐 로그인 여부를 확인합니다.
    func checkLoginBeforeAction(onLoggedIn: @escaping () -> Void) {
        let isLoggedIn = TokenKeyChainManager.shared.isLoggedIn
        
        if !isLoggedIn {
            presentLoginRequiredAlert()
        } else {
            onLoggedIn()
        }
    }
    
    func pushToLoginView() {
        let loginCoordinator: LoginCoordinator = DefaultLoginCoordinator(navigationController: navigationController)
        
        loginCoordinator.start()
    }
    
    func presentLoginRequiredAlert() {
        let loginAlertController: UIAlertController = UIAlertController(
            title: "로그인이 필요한 서비스 입니다.",
            message: "로그인을 하러 이동할까요?",
            preferredStyle: .alert
        )
        
        let okAction: UIAlertAction = UIAlertAction(
            title: "예",
            style: .default
        ) { [weak self] _ in
            self?.pushToLoginView()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "아니요",
            style: .cancel
        )
        
        loginAlertController.addAction(okAction)
        loginAlertController.addAction(cancelAction)
        
        navigationController.present(
            loginAlertController,
            animated: true
        )
    }
}
