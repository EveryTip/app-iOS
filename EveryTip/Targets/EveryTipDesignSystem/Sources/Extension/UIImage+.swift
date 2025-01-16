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
    case everyTipLogoimage
    case likeImage_empty
    case likeImage_fill
    case viewsImage
    case commentImage
    case searchIcon
    case everyTipLogo_story
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
        case .everyTipLogoimage: EveryTipDesignSystemAsset.everyTipLogo.image
        case .likeImage_empty:
            EveryTipDesignSystemAsset.likeImageEmpty.image
        case .likeImage_fill:
            EveryTipDesignSystemAsset.likeImageFill.image
        case .viewsImage:
            EveryTipDesignSystemAsset.viewsImage.image
        case .commentImage:
            EveryTipDesignSystemAsset.commentImage.image
        case .searchIcon:
            EveryTipDesignSystemAsset.searchIcon.image
        case .everyTipLogo_story:
            EveryTipDesignSystemAsset.everyTipLogoStory.image
        }
    }
}
