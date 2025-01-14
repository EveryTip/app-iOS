//
//  KeyChainError.swift
//  EveryTipCore
//
//  Created by 김경록 on 10/30/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public enum KeychainError: LocalizedError {
    case invalidItemFormat
    case unknown(OSStatus)
    case failedDataFormatting
    case failedGetItem
    case failedStoreItem
    case failedDeleteItem
    case failedUpdateItem
    
    public var errorDescription: String? {
        switch self {
        case .invalidItemFormat:
            return NSLocalizedString("정상적이지 못한 키체인 포맷입니다.", comment: "Invalid Item Format")
        case .unknown(_):
            return NSLocalizedString("알 수 없는 에러가 발생했습니다.", comment: "Unknown Error")
        case .failedDataFormatting:
            return NSLocalizedString("데이터 포맷팅 중 에러가 발생했습니다.", comment: "Data Formatting is Failed")
        case .failedGetItem:
            return NSLocalizedString("해당되는 키체인 아이템을 찾을 수 없습니다.", comment: "Item Not Found")
        case .failedStoreItem:
            return NSLocalizedString("키체인을 저장하는 중 에러가 발생했습니다.", comment: "Failed to store keychain item")
        case .failedDeleteItem:
            return NSLocalizedString("키체인을 삭제하는 중 에러가 발생했습니다.", comment: "Failed to delete keychain item")
        case .failedUpdateItem:
            return NSLocalizedString("키체인을 업데이트하는 중 에러가 발생했습니다.", comment: "Failed to Update keychain item")
        }
    }
}
