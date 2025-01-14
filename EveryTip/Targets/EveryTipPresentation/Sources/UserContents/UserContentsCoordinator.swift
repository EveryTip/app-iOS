//
//  UserHistoryCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain
import EveryTipCore

import RxSwift

protocol UserContentsCoordinator: AuthenticationCoordinator {
    func pushToOnlyUserView()
}

final class DefaultUserContentsCoordinator: UserContentsCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        let userContentsViewController: UserContentsViewController = UserContentsViewController()
        userContentsViewController.coordinator = self
        navigationController.pushViewController(
            userContentsViewController,
            animated: true
        )
    }
    
    func pushToOnlyUserView() {
        print("온리유저뷰 이동시켜줘잉")
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
