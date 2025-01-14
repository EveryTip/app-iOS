//
//  UserInfoViewCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import Swinject

import EveryTipDomain
import EveryTipCore
import RxSwift
protocol UserInfoViewCoordinator: AuthenticationCoordinator {
    func start() -> UIViewController
    func pushToAgreementViewcontroller()
    func pushToUserContentsView()
}

final class DefaultUserInfoViewCoordinator: UserInfoViewCoordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let container = Container.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start() -> UIViewController {
        guard let useCase = container.resolve(UserInfoUseCase.self) else {
            fatalError("의존성 주입이 옳바르지않습니다! \(self)")
        }
        let reactor = UserInfoReactor(userInfoUserCase: useCase)
        
        let userInfoViewController = UserInfoViewController(reactor: reactor)
        userInfoViewController.coordinator = self
        return userInfoViewController
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func pushToAgreementViewcontroller() {
        let agreementCoordinator = DefaultAgreementCoordinator(navigationController: navigationController)
        self.childCoordinators.append(agreementCoordinator)
        agreementCoordinator.start()
    }
    
    func pushToUserContentsView() {
        let userContentsCoordinator = DefaultUserContentsCoordinator(navigationController: navigationController)
            userContentsCoordinator.parentCoordinator = self
            self.append(child: userContentsCoordinator)
            userContentsCoordinator.start()
    }
}
