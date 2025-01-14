//
//  MainCoordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import EveryTipCore

import UIKit

import Swinject

public protocol MainCoordinator: Coordinator {
    
}

public final class DefaultMainCoordinator: MainCoordinator {
    public var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []
    public var navigationController: UINavigationController
    
    private let container: Container = .shared
    
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        startMainTab()
    }
    
    public func didFinish() {}
    
    private func startMainTab() {
        // TODO: 메인 탭 구현 & 연결
        guard let mainTabCoordinator = container.resolve(MainTabCoordinator.self) else {
            return
        }
        mainTabCoordinator.parentCoordinator = self
        append(child: mainTabCoordinator)
        
        mainTabCoordinator.start()
    }
}
