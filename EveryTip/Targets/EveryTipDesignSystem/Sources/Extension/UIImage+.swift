//
//  UIImage+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 8/8/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public enum ImageAssetType {
    case homeViewEmoji
    case categoryViewBanner
}

extension UIImage {
    public static func et_getImage(for imageAsset: ImageAssetType) -> UIImage {
        
        switch imageAsset {
        case .homeViewEmoji:  EveryTipDesignSystemAsset.homeViewEmoji.image
            
        case.categoryViewBanner:
            EveryTipDesignSystemAsset.categoryViewBanner.image
        }
    }
}
