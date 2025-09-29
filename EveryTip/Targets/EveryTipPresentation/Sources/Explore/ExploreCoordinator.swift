//
//  ExploreCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/2/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject
import ReactorKit

protocol ExploreCoordinator: Coordinator {
    func start() -> UIViewController
    func pushToTipDetailView(with tipID: Int)
}

final class DefaultExploreCoordinator: ExploreCoordinator {

    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start() -> UIViewController {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self),
              let UserUseCase = Container.shared.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 올바르지 않습니다!")
        }
        let reactor = ExploreReactor(tipUseCase: tipUseCase, userUseCase: UserUseCase)
        let exploreViewController = ExploreViewController(reactor: reactor)
        exploreViewController.coordinator = self
        
        return exploreViewController
    }

    func didFinish() {
        remove(child: self)
    }
    
    func pushToTipDetailView(with tipID: Int) {
        let tipDetailCoordinator = DefaultTipDetailCoordinator(
            tipId: tipID,
            navigationController: navigationController
        )
        tipDetailCoordinator.parentCoordinator = self
        append(child: tipDetailCoordinator)
        
        tipDetailCoordinator.start()
    }
}
