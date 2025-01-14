//
//  PostListCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/3/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import SnapKit

import EveryTipDesignSystem

final class PostListCell: UITableViewCell, Reusable {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.et_pretendard(style: .bold, size: 16)
        
        return label
    }()
    
    let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        label.numberOfLines = 2
        label.textColor = UIColor.et_textColorBlack50
        
        return label
    }()
    
    let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .blankImage)
        
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 12
        )
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let viewsImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .viewsImage)
        
        return imageview
    }()
    
    let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let commentsImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .commentImage)
        
        return imageview
    }()
    
    let commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.text = "0"
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    let likesImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .likeImage_empty)
        imageview.tintColor = UIColor(hex: "#777777")
        
        return imageview
    }()
    
    let likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    
    func configureTitleLabelText(_ text: String) {
        let categoryWidth = calculateLabelWidth(for: categoryLabel)
        let space = createDynamicSpace(forWidth: categoryWidth, withFont: titleLabel.font)
        let titleText = text
        titleLabel.text = space + titleText
    }
    
    func configureCategoryLabel(id: Int) {
        categoryLabel.setCategory(with: id)
    }
    
    // MARK: Private Methods
    
    private func calculateLabelWidth(for label: UILabel) -> CGFloat {
        guard let text = label.text else { return 0 }
        let font = label.font ?? UIFont.et_pretendard(style: .bold, size: 12)
        let size = (text as NSString).size(withAttributes: [.font: font])
        return size.width + 5 // 텍스트 패딩 포함
    }
    
    private func createDynamicSpace(forWidth width: CGFloat, withFont font: UIFont) -> String {
        let spaceCharWidth = " ".size(withAttributes: [.font: font]).width // 공백 문자 하나의 넓이
        let spaceCount = Int(ceil(width / spaceCharWidth)) // 필요한 공백 문자 수 계산
        return String(repeating: " ", count: spaceCount)
    }
    
    // MARK: Layout Methods
    
    private func setupLayout() {
        contentView.addSubViews(
            categoryLabel,
            titleLabel,
            mainTextLabel,
            viewsImage,
            viewsCountLabel,
            commentsImage,
            commentsCountLabel,
            likesImage,
            likesCountLabel,
            thumnailImageView,
            userNameLabel
        )
    }
    
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(contentView.snp.leading)
            $0.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(thumnailImageView.snp.leading).offset(-20)
        }
        
        mainTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(thumnailImageView.snp.leading).offset(-10)
            $0.height.equalTo(40)
        }
        
        viewsImage.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.height.equalTo(14)
        }
        
        viewsCountLabel.snp.makeConstraints {
            $0.leading.equalTo(viewsImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        commentsImage.snp.makeConstraints {
            $0.leading.equalTo(viewsCountLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.height.equalTo(14)
        }
        
        commentsCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentsImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        likesImage.snp.makeConstraints {
            $0.leading.equalTo(commentsCountLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
        
        likesCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likesImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    
        thumnailImageView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(thumnailImageView.snp.bottom).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
}
