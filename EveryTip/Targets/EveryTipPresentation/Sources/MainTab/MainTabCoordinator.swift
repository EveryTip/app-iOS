//
//  MainTabCoordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

protocol MainTabCoordinator: Coordinator {
    func presentPostView()
}

final class DefaultMainTabCoordinator: MainTabCoordinator {
    
    //MARK: Internal Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: Private Properties
    
    private let mainTabBarController = MainTabBarContoller()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Internal Methods
    
    func start() {
        // TODO: 각 ViewController, Coordinator 정의 및 start 메서드 실행
        let emptyVC = UIViewController()
        emptyVC.tabBarItem.isEnabled = false
        
        let homeCoordinator = DefaultHomeViewCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        append(child: homeCoordinator)
        
        let categoryCoordinator = DefaultCategoryViewCoordinator(navigationController: navigationController)
        categoryCoordinator.parentCoordinator = self
        append(child: categoryCoordinator)
        
        let exploreCoordinator = DefaultExploreCoordinator(navigationController: navigationController)
        exploreCoordinator.parentCoordinator = self
        append(child: exploreCoordinator)
        
        let userInfoCoodinator = DefaultMyInfoViewCoordinator(navigationController: navigationController)
        userInfoCoodinator.parentCoordinator = self
        append(child: userInfoCoodinator)
        
        mainTabBarController.viewControllers = [
            homeCoordinator.start(),
            categoryCoordinator.start(),
            emptyVC,
            exploreCoordinator.start(),
            userInfoCoodinator.start()
        ]
        
        mainTabBarController.configureMainTabBarController()
        mainTabBarController.coordinator = self

        navigationController.setViewControllers(
            [mainTabBarController],
            animated: true
        )
    }
    
    func presentPostView() {
        let postCoordinator = DefaultPostTipViewCoordinator(
            navigationController: navigationController,
            presentingViewController: mainTabBarController
        )
        postCoordinator.parentCoordinator = self
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
    }
    
    func didFinish() {}
}
