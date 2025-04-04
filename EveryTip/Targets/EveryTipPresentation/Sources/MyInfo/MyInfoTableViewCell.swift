//
//  UserInfoTableViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class MyInfoTableViewCell: UITableViewCell, Reusable {
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        return label
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
    }
    
    private func setupConstraints() {
        leftLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(20)
            $0.leading.equalTo(contentView).offset(30)
        }
        
        rightLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(20)
            $0.trailing.equalTo(contentView).offset(-20)
        }
    }
}
