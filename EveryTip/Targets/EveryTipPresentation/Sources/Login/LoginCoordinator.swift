//
//  LoginCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/1/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit
import EveryTipDomain

import Swinject

protocol LoginCoordinator: Coordinator {
    func startAndReturnViewController() -> UIViewController
}

final class DefaultLoginCoordinator: LoginCoordinator {
   
    let container = Container.shared
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let useCase = container.resolve(RequestTokenUseCase.self) else {
            fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        let reactor = LoginReactor(loginUseCase: useCase)
        let loginViewController = LoginViewController(reactor: reactor)
        loginViewController.coordinator = self
        
        navigationController.pushViewController(
            loginViewController,
            animated: true
        )
    }
    
    func startAndReturnViewController() -> UIViewController {
        guard let useCase = container.resolve(RequestTokenUseCase.self) else {
            fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        let reactor = LoginReactor(loginUseCase: useCase)
        let loginViewController = LoginViewController(reactor: reactor)
        loginViewController.coordinator = self
        return loginViewController
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
