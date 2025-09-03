//
//  BlockManager.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

struct BlockManager {
    private static let key = "blockedUserIds"
    
    static var blockedUserIds: Set<Int> {
        get {
            let ids = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
            return Set(ids)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }
    
    static func block(userId: Int) {
        var ids = blockedUserIds
        ids.insert(userId)
        blockedUserIds = ids
    }
    
    static func unblock(userId: Int) {
        var ids = blockedUserIds
        ids.remove(userId)
        blockedUserIds = ids
    }
    
    static func isBlocked(userId: Int) -> Bool {
        return blockedUserIds.contains(userId)
    }
}
