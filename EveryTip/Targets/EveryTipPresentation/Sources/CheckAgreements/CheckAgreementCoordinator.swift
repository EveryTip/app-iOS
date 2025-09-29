//
//  CheckAgreementCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/21/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import Swinject

import EveryTipDomain

protocol CheckAgreementCoordinator: Coordinator {
    func pushToSignupSuccessView()
    func pushToAgreementView()
}

final class DefaultCheckAgreementCoordinator: CheckAgreementCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    private var signupData: SignupData
    
    init(
        navigationContoller: UINavigationController,
        signupData: SignupData
    ) {
        self.navigationController = navigationContoller
        self.signupData = signupData
    }
    
    func start() {
        guard let authUseCsae = Container.shared.resolve(AuthUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다.")
        }
        let reactor = CheckAgreementsReactor(
            authUseCase: authUseCsae,
            signupdata: signupData
            )
        let checkAgreementViewController = CheckAgreementViewController(reactor: reactor)
        
        checkAgreementViewController.modalPresentationStyle = .overFullScreen
        
        checkAgreementViewController.coordinator = self
        navigationController.present(checkAgreementViewController, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func pushToSignupSuccessView() {
        navigationController.dismiss(animated: true) { [ weak self] in
            guard let self = self else { return }
            let signupSuccessCoordinator = DefaultSignupSuccessCoordinator(
                navigationContoller: navigationController
            )
            
            signupSuccessCoordinator.parentCoordinator = self
            self.append(child: signupSuccessCoordinator)
            
            signupSuccessCoordinator.start()
        }
    }
    
    func pushToAgreementView() {
        navigationController.dismiss(animated: true) { [ weak self] in
            guard let self = self else { return }
            let agreementCoordinator = DefaultAgreementCoordinator(navigationController: navigationController)
            self.append(child: agreementCoordinator)
            agreementCoordinator.start()
        }
    }
}
