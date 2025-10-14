//
//  InteractivePoppableNavigationController.swift
//  EveryTip
//
//  Created by 손대홍 on 1/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public final class InteractivePoppableNavigationController: UINavigationController {
    
    private let titleLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "every tip"
        label.textColor = .white
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 20
        )
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(
            UIImage.et_getImage(for: .searchIcon), for: .normal
        )
        button.tintColor = .white
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(
            type: .system
        )
        let boldConfig = UIImage.SymbolConfiguration(
            weight: .bold
        )
        button.setImage(
            UIImage.et_getImage(for: .bell), for: .normal
        )
        button.tintColor = .white
        return button
    }()
    
    private var backButtonImage: UIImage? {
        return UIImage.et_getImage(for: .backButton).withAlignmentRectInsets(
            UIEdgeInsets(
                top: 0,
                left: -10,
                bottom: 0,
                right: 0
            )
        )
    }
    
    private var backButtonAppearance: UIBarButtonItemAppearance {
        let appearance = UIBarButtonItemAppearance()
        appearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]
        return appearance
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: nil, bundle: nil)
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 스타일: 일반 스타일
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(
            backButtonImage,
            transitionMaskImage: backButtonImage
        )
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.et_pretendard(style: .semiBold, size: 20)
        ]
        
        appearance.backButtonAppearance = backButtonAppearance
        appearance.backgroundColor = .white
        // 반투명 off
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .black
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        // standardAppearance  일반적인 상태에서 사용
        // compactAppearance  화면이 작을 때 (예: 가로모드)
        // scrollEdgeAppearance  스크롤이 상단에 있을 때 (투명/불투명 결정 등)
    }
    
    // MARK: - 스타일: 루트 뷰컨 스타일
    private func setupRootNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .et_brandColor2
        appearance.shadowColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        
        // 왼쪽 타이틀
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLogoLabel)

        
        
        // TODO: 알림 기능 업데이트 시 업데이트
//        // 오른쪽 버튼들
//        let stackView = UIStackView(
//            arrangedSubviews: [
//                searchButton,
//                notificationButton
//            ]
//        )
//        stackView.axis = .horizontal
//        stackView.spacing = 14
//        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    // MARK: 스타일: Edit Profile
    
    private func setupEditProfileNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .et_brandColor2
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
               .foregroundColor: UIColor.white,
               .font: UIFont.et_pretendard(style: .semiBold, size: 18)
           ]
        appearance.setBackIndicatorImage(
            backButtonImage,
            transitionMaskImage: backButtonImage
        )
        appearance.backButtonAppearance = backButtonAppearance

        topViewController?.navigationItem.title = "프로필 편집"
        navigationBar.tintColor = .white
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        
    }
    
    private func setupSearchNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.et_pretendard(style: .semiBold, size: 20)
        ]
        
        appearance.setBackIndicatorImage(
            backButtonImage,
            transitionMaskImage: backButtonImage
        )
        appearance.backButtonAppearance = backButtonAppearance
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .black
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

extension InteractivePoppableNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // count > 1일 경우 other gesture 들은 무시된다.
        return viewControllers.count > 1
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // count > 1일 경우에만 gesture begin
        return viewControllers.count > 1
    }
}

// MARK: - 화면 전환 시 네비게이션 바 스타일 처리
extension InteractivePoppableNavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if viewController == viewControllers.first {
            setupRootNavigationBar()
        } else if viewController is EditProfileViewController {
            setupEditProfileNavigationBar()
        } else if viewController is SearchViewController {
            setupSearchNavigationBar()
        }
        else {
            setupNavigationBar()
        }
    }
}
