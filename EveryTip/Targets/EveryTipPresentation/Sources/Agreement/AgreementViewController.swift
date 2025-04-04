//
//  AgreementViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 9/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

import Alamofire
import EveryTipDomain

import EveryTipData

final class AgreementViewController: BaseViewController {
    weak var coordinator: AgreementCoordinator?
    var disposeBag = DisposeBag()
    
    var useCase: AuthUseCase?

    init(useCase: AuthUseCase) {
        super.init(nibName: nil, bundle: nil)
        self.useCase = useCase
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        guard let dd = useCase else {
            return
        }
        
        dd.getAgreements()
    }
}
