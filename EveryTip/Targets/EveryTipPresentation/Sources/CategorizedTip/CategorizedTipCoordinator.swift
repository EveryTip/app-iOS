//
//  CategorizedTipCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol CategorizedTipCoordinator: Coordinator {
    func pushToTipDetailView(with tipID: Int)
    func popView()
}

final class DefaultCategorizedTipCoordinator: CategorizedTipCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let categoryID: Int
    
    init(navigationController: UINavigationController,
         categoryID: Int) {
        self.navigationController = navigationController
        self.categoryID = categoryID
    }
    
    func start() {
        
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다!")
        }
        
        let reactor = CategorizedTipReactor(tipUseCase: tipUseCase, categoryID: categoryID)
        let vc = CategorizedTipViewController(reactor: reactor)
        vc.coordinator = self
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
        didFinish()
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
