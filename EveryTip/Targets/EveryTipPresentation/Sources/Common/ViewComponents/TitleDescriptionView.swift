//
//  TitleDescriptionView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class TitleDescriptionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .bold,
            size: 24
        )
        label.textColor = .black
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .regular,
            size: 16
        )
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()

    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        setupLayout()
        setupConstraints()
        configure(title: title, subTitle: subTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubViews(
            titleLabel,
            subTitleLabel
        )
    }
    
    private func setupConstraints() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.snp.leading)
        }
    }
    
    private func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
