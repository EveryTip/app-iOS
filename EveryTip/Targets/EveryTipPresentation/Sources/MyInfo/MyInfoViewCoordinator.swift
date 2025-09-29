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
protocol MyInfoViewCoordinator: AuthenticationCoordinator {
    func start() -> UIViewController
    func pushToAgreementViewcontroller()
    func pushToUserContentsView(myID: Int)
    func pushToEditProfileView(myNickName: String)
    func pushToSetCategory()
    func popToRootView()
}

final class DefaultMyInfoViewCoordinator: MyInfoViewCoordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let container = Container.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start() -> UIViewController {
        guard let useCase = container.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다! \(self)")
        }
        let reactor = MyInfoReactor(userUseCase: useCase)
        
        let userInfoViewController = MyInfoViewController(reactor: reactor)
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
    
    func pushToUserContentsView(myID: Int) {
        let userContentsCoordinator = DefaultUserContentsCoordinator(
            myID: myID,
            navigationController: navigationController
        )
            userContentsCoordinator.parentCoordinator = self
            self.append(child: userContentsCoordinator)
            userContentsCoordinator.start()
    }
    
    func pushToSetCategory() {
        let setCategoryCoordinator = DefaultSetCategoryCoordinator(navigationController: navigationController)
        self.append(child: setCategoryCoordinator)
        setCategoryCoordinator.parentCoordinator = self
        setCategoryCoordinator.start()
    }
    
    func pushToEditProfileView(myNickName: String) {
        let editProfileCoordinator = DefaultEditProfileCoordinator(
            navigationController: navigationController,
            myNickName: myNickName
        )
        editProfileCoordinator.parentCoordinator = self
        self.append(child: editProfileCoordinator)
        
        editProfileCoordinator.start()
    }
    
    func popToRootView() {
        didFinish()
        navigationController.popToRootViewController(animated: true)
    }
}
