//
//  EditPasswordCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol EditPasswordCoordinator: Coordinator {
    func popToRootView()
}

final class DefaultEditPasswordCoordinator: EditPasswordCoordinator {
  
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let authUseCase = Container.shared.resolve(AuthUseCase.self) else {
            fatalError("의존성 주입이 올바르지 않습니다")
        }
        let reactor = EditPasswordReactor(authUseCase: authUseCase)
        let editPasswordVC = EditPasswordViewController(reactor: reactor)
        editPasswordVC.coordinator = self
        navigationController.pushViewController(editPasswordVC, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func popToRootView() {
        didFinish()
        navigationController.popToRootViewController(animated: true)
    }
}
