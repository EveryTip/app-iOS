//
//  TokenKeyChainManager.swift
//  EveryTipCore
//
//  Created by 김경록 on 10/30/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

// TODO: 키체인 매니저가 독립적으로 작동할 수 있도록 변경
public final class TokenKeyChainManager {
    
    public static let shared = TokenKeyChainManager()
    private init() {}
    
    public var isLoggedIn: Bool {
        get {
            return getToken(type: .access) != nil
        }
    }
    
    let serviceName = "com.everytip.service.jwt"
    // KeyChain Type으로 분리
    public enum TokenType {
        case access
        case refresh

        var accountName: String {
            switch self {
            case .access:
                return "et_AccessToken"
            case .refresh:
                return "et_RefreshToken"
            }
        }
    }
    // MARK: - Private Methods
    
    @discardableResult
    public func getToken(type: TokenType) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: type.accountName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess,
           let retrievedData = dataTypeRef as? Data,
           let token = String(data: retrievedData, encoding: .utf8) {
            return token
        } else {
            print("\(type), \(KeychainError.failedGetItem), 에러코드: \(status)")
        }
        
        return nil
    }
    
    @discardableResult
    public func storeToken(_ token: String, type: TokenType) -> Bool {
        guard let tokenData = token.data(using: .utf8) else {
            print("\(type), \(KeychainError.failedDataFormatting)")
            return false
        }
        
        if getToken(type: type) != nil {
            return updateToken(tokenData, type: type)
        } else {
            let tokenQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: type.accountName,
                kSecValueData as String: tokenData,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            
            let status = SecItemAdd(tokenQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else {
                print("\(type), \(KeychainError.failedStoreItem), 에러코드: \(status)")
                return false
            }
        }
    }
    
    @discardableResult
    public func deleteToken(type: TokenType) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: type.accountName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            print("\(type), \(KeychainError.failedDeleteItem), 에러코드: \(status)")
            return false
        }
    }
    
    @discardableResult
    public func updateToken(_ tokenData: Data, type: TokenType) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: type.accountName
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            print("\(type), \(KeychainError.failedUpdateItem), 에러코드: \(status)")
            return false
        }
    }
}
