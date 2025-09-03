//
//  BlockedListCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol BlockedListCoordinator: Coordinator {
    
}

final class DefaultBlockedListCoordinator: BlockedListCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let blockedListViewController = BlockedListViewController()
        blockedListViewController.coordinator = self
        
        navigationController.pushViewController(blockedListViewController, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
