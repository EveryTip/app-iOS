//
//  SectionedTipCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/9/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol SectionedTipCoordinator: Coordinator {
    func pushToTipDetail(tipID: Int)
}

final class DefaultSectionedTipCoordinator: SectionedTipCoordinator {
    typealias SectionType = HomeSectionHeaderView.SectionType
    typealias Category = EveryTipDomain.Category
    
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let sectionType: SectionType
    private let categoires: [Category]
    
    init(navigationController: UINavigationController,
         sectionType: SectionType,
         categories: [Category]) {
        self.navigationController = navigationController
        self.sectionType = sectionType
        self.categoires = categories
    }
    
    func start() {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다")
        }
        
        let reactor = SectionedTipReactor(
            tipUseCase: tipUseCase,
            sectionType: sectionType,
            myCategories: categoires
        )
        let sectionedTipViewController =  SectionedTipViewController(reactor: reactor)
        sectionedTipViewController.coordinator = self
    
        navigationController.pushViewController(sectionedTipViewController, animated: true)
    }
    
    func pushToTipDetail(tipID: Int) {
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
