//
//  PostListCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class PostListCell: UITableViewCell, Reusable {
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        
        // TODO: 각 카테고리 라벨별 색깔 지정 처리
        label.backgroundColor = UIColor(red: 0.98, green: 0.88, blue: 0.89, alpha: 1.00)
        label.textColor = UIColor(red: 0.91, green: 0.30, blue: 0.40, alpha: 1.00)
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 16
        )
        
        return label
    }()
    
    let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        label.numberOfLines = 2
        label.textColor = .et_textColorBlack50
        
        return label
    }()
    
    // TODO: 현재 기본 이미지, 추후 서버 이미지로 처리 시 적절한 cornerRadius 설정 필요
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 12
        )
        
        return label
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        stackView.sizeToFit()
        
        return stackView
    }()
    
    let viewCountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 12
        )
        
        return label
    }()
    
    private lazy var viewCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // TODO: 내가 좋아요 표시 한 경우 빨간색으로 표시
    let likeCountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .gray
        
        return imageView
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 12
        )
        
        return label
    }()
    
    private lazy var likeCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        titleLabel.addSubview(categoryLabel)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(userStackView)
        userStackView.addArrangedSubview(userImageView)
        userStackView.addArrangedSubview(userNameLabel)
        
        contentView.addSubview(likeCountStackView)
        likeCountStackView.addArrangedSubview(likeCountImageView)
        likeCountStackView.addArrangedSubview(likeCountLabel)
        
        contentView.addSubview(viewCountStackView)
        viewCountStackView.addArrangedSubview(viewCountImageView)
        viewCountStackView.addArrangedSubview(viewCountLabel)
        
        contentView.addSubview(thumbnailImageView)
        
        contentView.addSubview(mainTextLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-15)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.leading.equalTo(titleLabel)
        }
        
        mainTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView).offset(-120)
        }
        
        userImageView.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        likeCountImageView.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        viewCountImageView.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        userStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(mainTextLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.3)
        }
        
        viewCountStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(mainTextLabel.snp.bottom).offset(10)
            $0.leading.equalTo(userStackView.snp.trailing).offset(3)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.2)
        }
        
        likeCountStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(mainTextLabel.snp.bottom).offset(10)
            
            $0.leading.equalTo(viewCountStackView.snp.trailing).offset(3)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.2)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.26)
            $0.height.equalTo(thumbnailImageView.snp.width)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-15)
        }
    }
}
