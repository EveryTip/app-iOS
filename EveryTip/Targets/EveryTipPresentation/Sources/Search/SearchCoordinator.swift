//
//  SearchCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol SearchCoordinator: Coordinator {
    func popView()
    func pushToTipDetailView(with tipID: Int)
}

final class DefaultSearchCoordinator: SearchCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self),
              let searchHistoryUseCase = Container.shared.resolve(SearchHistoryUseCase.self)
        else {
            fatalError("의존성 주입이 올바르지 않습니다")
        }
        let searchReactor = SearchReactor(
            tipUseCase: tipUseCase,
            searchHistoryUseCase: searchHistoryUseCase
        )
        let searchView = SearchViewController(reactor: searchReactor)
        searchView.coordinator = self
        navigationController.pushViewController(searchView, animated: true)
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

    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
