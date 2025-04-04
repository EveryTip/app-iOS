//
//  Constraint.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public struct Constants {
    public struct MyInfo {
        public static let tableViewItems: [String] = [
            "공지사항",
            "고객센터",
            "구독 설정",
            "관심사 설정",
            "이용약관",
            "버전",
            "로그아웃"
        ]
    }
    
    public enum Category: CaseIterable {
        case hobby
        case it
        case health
        case finance
        case entertainment
        case sports
        case games
        case social
        
        var image: UIImage? {
            switch self {
            case .hobby:
                return UIImage.et_getImage(for: .categoryIcon_hobby)
            case .it:
                return UIImage.et_getImage(for: .categoryIcon_it)
            case .health:
                return UIImage.et_getImage(for: .categoryIcon_health)
            case .finance:
                return UIImage.et_getImage(for: .categoryIcon_finance)
            case .entertainment:
                return UIImage.et_getImage(for: .categoryIcon_entertainment)
            case .sports:
                return UIImage.et_getImage(for: .categoryIcon_sports)
            case .games:
                return UIImage.et_getImage(for: .categoryIcon_games)
            case .social:
                return UIImage.et_getImage(for: .categoryIcon_social)
            }
        }
        
        var title: String {
            switch self {
            case .hobby:
                return "취미/생활"
            case .it:
                return "IT"
            case .health:
                return "건강"
            case .finance:
                return "금융"
            case .entertainment:
                return "연예/방송"
            case .sports:
                return "스포츠"
            case .games:
                return "게임"
            case .social:
                return "사회"
            }
        }
        
        public static let allCategoriesItems: [Category] = Category.allCases
        
        public static let interestSuggestItems: [Category] = [.hobby, .it, .health, .finance, .entertainment, .games]
    }
}
