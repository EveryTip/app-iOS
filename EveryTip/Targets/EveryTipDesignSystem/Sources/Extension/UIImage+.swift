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
    case blankImage
    case sortImage_latest
    case sortImage_likes
    case sortImage_views
}

extension UIImage {
    public static func et_getImage(for imageAsset: ImageAssetType) -> UIImage {
        
        switch imageAsset {
        case .homeViewEmoji: EveryTipDesignSystemAsset.homeViewEmoji.image
        case .categoryViewBanner: EveryTipDesignSystemAsset.categoryViewBanner.image
        case .blankImage: EveryTipDesignSystemAsset.blankImage.image
        case .sortImage_latest:
            EveryTipDesignSystemAsset.sortImageLatest.image
        case .sortImage_likes:
            EveryTipDesignSystemAsset.sortImageLikes.image
        case .sortImage_views:
            EveryTipDesignSystemAsset.sortImageViews.image
        }
    }
}
