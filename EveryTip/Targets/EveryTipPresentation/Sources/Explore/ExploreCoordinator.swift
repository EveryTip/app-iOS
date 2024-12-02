//
//  ExploreCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/2/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

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
        
    func start() {
        let exploreViewController = ExploreViewController()
        exploreViewController.coordinator = self
    }
    
    func start() -> UIViewController {
        let exploreViewController = ExploreViewController()
        exploreViewController.coordinator = self
        
        return exploreViewController
    }

    func didFinish() {
        remove(child: self)
    }
}
