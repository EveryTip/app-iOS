//
//  UserLoginRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol UserLoginRepository {
    func login(with email: String, password: String) -> Single<TokenResponse>
}
