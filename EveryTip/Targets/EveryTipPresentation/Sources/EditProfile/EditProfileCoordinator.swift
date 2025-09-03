//
//  EditProfileCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/26/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol EditProfileCoordinator: AuthenticationCoordinator {
    func popToRootView()
    func pushToEditPassword()
    func pushToBlockedList()
}

final class DefaultEditProfileCoordinator: EditProfileCoordinator {
   
   
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController,
         myNickName: String) {
        self.navigationController = navigationController
        self.myNickName = myNickName
    }
    
    private let myNickName: String
    
    func start() {
        guard let authUseCase = Container.shared.resolve(AuthUseCase.self) else { fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        
        let reactor = EditProfileReactor(authUseCase: authUseCase, nickName: myNickName)
        
        let vc = EditProfileViewController(reactor: reactor)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToRootView() {
        navigationController.popViewController(animated: true)
        didFinish()
    }
    
    func pushToEditPassword() {
        let editPasswordCoordinator = DefaultEditPasswordCoordinator(navigationController: navigationController)
        self.append(child: editPasswordCoordinator)
        
        editPasswordCoordinator.start()
    }
    
    func pushToBlockedList() {
        let blockedListCoordinator = DefaultBlockedListCoordinator(navigationController: navigationController)
        self.append(child: blockedListCoordinator)
        
        blockedListCoordinator.start()
    }

    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
