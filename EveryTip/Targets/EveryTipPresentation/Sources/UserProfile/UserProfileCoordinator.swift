//
//  UserProfileCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol UserProfileCoordinator: AuthenticationCoordinator {
    func pushToTipDetailView(tipID: Int)
}

final class DefaultUserProfileCoordinator: UserProfileCoordinator {
    
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController,
        userID: Int
    ) {
        self.navigationController = navigationController
        self.userID = userID
    }
    
    private let userID: Int
    
    func start() {
        let container = Container.shared
        
        guard let userUseCase = container.resolve(UserUseCase.self),
              let tipUseCaes = container.resolve(TipUseCase.self)
        else {
            fatalError("의존성 주입이 올바르지 않습니다!")
        }
        
        let userProfileReactor = UserProfileReactor(
            userID: userID,
            userUseCase: userUseCase,
            tipUseCase: tipUseCaes)
        let userProfileVC = UserProfileViewController(reactor: userProfileReactor)
        userProfileVC.coordinator = self
        
        navigationController.pushViewController(userProfileVC, animated: true)
    }
    
    func pushToTipDetailView(tipID: Int) {
        let tipDetailCoordinator = DefaultTipDetailCoordinator(
            tipId: tipID,
            navigationController: navigationController
        )
        
        tipDetailCoordinator.parentCoordinator = self
        self.append(child: tipDetailCoordinator)
        tipDetailCoordinator.start()
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
