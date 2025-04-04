//
//  AgreementCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 9/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import UIKit

import EveryTipDomain

import Swinject

protocol AgreementCoordinator: Coordinator { }

final class DefaultAgreementCoordinator: AgreementCoordinator {
        
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let useCase = Container.shared.resolve(AuthUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다!")
        }
        
        let agreementViewController = AgreementViewController(useCase: useCase)
        agreementViewController.coordinator = self
        navigationController.pushViewController(agreementViewController, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
