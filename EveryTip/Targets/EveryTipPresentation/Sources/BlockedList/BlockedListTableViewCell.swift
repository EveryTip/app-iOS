//
//  BlockedListTableViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import RxSwift

final class BlockedListTableViewCell: UITableViewCell, Reusable {
    
    let removeButtonTapped = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 17
        imageView.clipsToBounds = true
        imageView.image = .et_getImage(for: .blankImage)
        
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .medium,
            size: 16
        )
        label.textColor = .et_textColorBlack90
        
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단 해제", for: .normal)
        button.tintColor = UIColor(hex: "#E84D65")
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            profileImageView,
            nickNameLabel,
            removeButton
        )
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(34)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.top.equalTo(contentView.snp.top).offset(21)
            $0.bottom.equalTo(contentView.snp.bottom)
                .offset(-22)
        }
        
        removeButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(22)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom).offset(-23)
        }
    }
    
    func configure(
        userID: Int,
        at index: Int
    ) {
        nickNameLabel.text = "\(userID)"
        removeButton.rx.tap
            .bind(to: removeButtonTapped)
            .disposed(by: disposeBag)
    }
}
