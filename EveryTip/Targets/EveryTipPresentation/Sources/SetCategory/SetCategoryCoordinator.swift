//
//  SetCategoryCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol SetCategoryCoordinator: Coordinator {
    func popToRootView()
}

final class DefaultSetCategoryCoordinator: SetCategoryCoordinator {

    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let userUseCase = Container.shared.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 올바르지 않습니다!")
        }
        let reactor = SetCategoryReactor(userUseCase: userUseCase)
        let viewController = SetCategoryViewController(reactor: reactor)
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func popToRootView() {
        didFinish()
        navigationController.popToRootViewController(animated: true)
    }
}
