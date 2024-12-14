//
//  ExploreCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/2/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import ReactorKit

protocol ExploreCoordinator: Coordinator {
    func start() -> UIViewController
}

final class DefaultExploreCoordinator: ExploreCoordinator {

    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    private let reactor = ExploreReactor()
    
    func start() {
        let exploreViewController = ExploreViewController(reactor: reactor)
        exploreViewController.coordinator = self
    }
    
    func start() -> UIViewController {
        let exploreViewController = ExploreViewController(reactor: reactor)
        exploreViewController.coordinator = self
        
        return exploreViewController
    }

    func didFinish() {
        remove(child: self)
    }
}
