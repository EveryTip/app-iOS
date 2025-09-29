//
//  TipDetailCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol TipDetailCoordinator: AuthenticationCoordinator {
    func pushToUserProrfileView(userID: Int)
    func presentDetailPhoto(with imageUrls: [String], startIndex: Int)
}

final class DefaultTipDetailCoordinator: TipDetailCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let tipId: Int
    
    init(
        tipId: Int,
        navigationController: UINavigationController
    ) {
        self.tipId = tipId
        self.navigationController = navigationController
    }
    
    func start() {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self),
              let commentUseCase = Container.shared.resolve(CommentUseCase.self)
        else {
            fatalError("의존성 주입이 올바르지 않습니다!")
        }
        let reactor = TipDetailReactor(
            tipID: tipId,
            tipUseCase: tipUseCase,
            commentUseCase: commentUseCase
        )
        let tipDetailVC = TipDetailViewController(reactor: reactor)
        tipDetailVC.coordinator = self
        navigationController.pushViewController(tipDetailVC, animated: true)
    }
    
    func pushToUserProrfileView(userID: Int) {
        let userProfileCoordinator = DefaultUserProfileCoordinator(
            navigationController: navigationController,
            userID: userID
        )
        self.append(child: userProfileCoordinator)
        userProfileCoordinator.parentCoordinator = self
        userProfileCoordinator.start()
    }

    func presentDetailPhoto(with imageUrls: [String], startIndex: Int) {
        let photoDetailCoordinator = DefaultPhotoDetailCoordinator(navigationController: navigationController)
        self.append(child: photoDetailCoordinator)
        
        photoDetailCoordinator.start(imageURLs: imageUrls, startIndex: startIndex
        )
    }
    
    func didFinish() {
        remove(child: self)
    }
}
