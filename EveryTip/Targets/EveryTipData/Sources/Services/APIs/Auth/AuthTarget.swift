//
//  File.swift
//  EveryTipData
//
//  Created by 김경록 on 9/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import Alamofire

enum AuthTarget {
    case getAgreements
    case postEmailCode(email: String)
    case postUserLogin(email: String, password: String)
}

extension AuthTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getAgreements:
                .get
        case .postEmailCode:
                .post
        case .postUserLogin:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .getAgreements:
            return "/auth/agreements"
        case .postEmailCode:
            return "/auth/verification/email"
        case .postUserLogin:
            return "/auth/sign-in"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAgreements:
            return nil
        case .postEmailCode(let email):
            return ["email": email]
        case .postUserLogin(email: let email, password: let password):
            return ["email": email, "password": password]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAgreements:
            return nil
        case .postEmailCode:
            return ["Content-Type": "application/json"]
        case .postUserLogin:
            return ["Content-Type": "application/json"]
        }
    }
}
