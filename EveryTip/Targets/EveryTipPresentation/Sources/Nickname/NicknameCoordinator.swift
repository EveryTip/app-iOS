//
//  NicknameCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol NicknameCoordinator: Coordinator {
    func presentAgreementBottomSheet()
}

final class DefaultNicknameCoordinator: NicknameCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
     
    var navigationController: UINavigationController
    
    private var signupData: SignupData
    
    init(
        navigationController: UINavigationController,
        signupData: SignupData
    ) {
        self.navigationController = navigationController
        self.signupData = signupData
    }
    
    func start() {
        guard let userUseCase = Container.shared.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 올바르지 않습니다!")
        }
        
        let nicknameReactor = NicknameReactor(userUseCase: userUseCase)
        let nicknameViewController = NicknameViewController(reactor: nicknameReactor)
        nicknameViewController.coordinator = self
        nicknameViewController.onConfirm = { [weak self] in
            guard let self = self else { return }
            let state = nicknameReactor.currentState
            let nickname = state.nicknameText
            signupData.nickname = nickname
        }
        
        navigationController.pushViewController(
            nicknameViewController,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
 
    func presentAgreementBottomSheet() {
        let agreementCoordinator = DefaultCheckAgreementCoordinator(
            navigationContoller: navigationController,
            signupData: signupData
        )
        agreementCoordinator.parentCoordinator = self
    
        self.append(child: agreementCoordinator)
        agreementCoordinator.start()
    }
}
