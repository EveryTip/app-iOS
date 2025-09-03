//
//  UserContentPlaceholderView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/8/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class UserContentPlaceholderView: UIView {
    
    enum UserContentType {
        case follower
        case following
        case myTip
        case savedTip
        case emptyTip
        case emptySearchResult
        case blockedUser
        
        var message: String {
            switch self {
            case .follower:
                return "구독자가 비어있어요. 팁을 작성해서 구독자를 늘려보세요!"
            case .following:
                return "구독 중인 유저가 없어요. 마음에 드는 유저를 구독해보세요!"
            case .myTip:
                return "작성한 팁이 없어요. 팁을 작성해보세요!"
            case .savedTip:
                return "저장한 팁이 없어요. 마음에 드는 팁을 저장해보세요!"
            case .emptyTip:
                return "아직 작성된 팁이 없어요 다른 팁도 구경해볼까요?"
            case .emptySearchResult:
                return "해당 검색어를 통한 결과가 없어요"
            case .blockedUser:
                return "차단 된 유저는 여기서 관리할 수 있어요"
            }
        }
    }
    
    private let blankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .placeholder)
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .regular, size: 14)
        label.textColor = .et_textColorBlack10
        return label
    }()
    
    init(type: UserContentType) {
        super.init(frame: .zero)
        setupLayout()
        configure(with: type)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(blankImageView)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        blankImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(86)
            $0.top.equalToSuperview().offset(204)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(blankImageView.snp.bottom).offset(8)
        }
    }
    
    
    private func configure(with type: UserContentType) {
        descriptionLabel.text = type.message
    }
}
