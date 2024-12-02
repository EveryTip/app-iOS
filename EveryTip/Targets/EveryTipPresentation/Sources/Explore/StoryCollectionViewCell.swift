//
//  StoryCollectionViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class StoryCollectionViewCell: UICollectionViewCell, Reusable {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: "#EEEEEE")
        imageView.layer.cornerRadius = 30
        
        return imageView
    }()
    
    let highlightOverlayView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.et_brandColor2.cgColor
        view.backgroundColor = UIColor.et_brandColor2
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        label.text = "몇글자까지되나요"
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuplayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setuplayout() {
        self.backgroundColor = .white
        profileImageView.addSubview(highlightOverlayView)
        contentView.addSubViews(
            profileImageView,
            userNameLabel
        )
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.width.height.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(5)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
