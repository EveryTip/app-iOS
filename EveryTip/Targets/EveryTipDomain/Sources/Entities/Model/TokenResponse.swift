//
//  Token.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct TokenResponse: Decodable {
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: TokenData
}

public struct TokenData: Decodable {
    public let id: Int
    public let email: String
    public let nickName: String
    public let accessToken: String
    public let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case nickName = "nick_name"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
