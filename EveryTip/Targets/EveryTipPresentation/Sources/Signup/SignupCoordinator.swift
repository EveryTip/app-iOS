//
//  SignupCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol SignupCoordinator: Coordinator { }

final class DefaultSignupCoordinator: SignupCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let authUseCase = Container.shared.resolve(AuthUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다")
        }
        
        let reactor = SignUpReactor(authUseCase: authUseCase)
        
        let signUpViewController = SignUpViewController(reactor: reactor)
        
        signUpViewController.coordinator = self
        navigationController.pushViewController(
            signUpViewController,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
