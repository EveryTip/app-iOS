//
//  ExploreViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class ExploreViewController: BaseViewController {
    
    weak var coordinator: ExploreCoordinator?
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
    
    private let exploreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 18
        )
        label.text = "전체 팁 목록 👀"
        
        return label
    }()
    
    private let storyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: 90,
            height: 100
        )
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 0
        )
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.indicatorStyle = .white
        
        collectionView.register(
            StoryCollectionViewCell.self,
            forCellWithReuseIdentifier: StoryCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage.et_getImage(for: .sortImage_latest)
        button.setImage(
            image,
            for: .normal
        )
        button.tintColor = UIColor.et_textColorBlack10
        
        return button
    }()
    
    private let postListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
        
        sortButton.addTarget(
            nil,
            action: #selector(showAlert),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        view.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubViews(
            exploreTitleLabel,
            storyCollectionView,
            sortButton,
            postListTableView
        )
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        exploreTitleLabel.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(20)
            $0.leading.equalTo(roundedBackgroundView.snp.leading).offset(20)
        }
        
        storyCollectionView.snp.makeConstraints {
            $0.top.equalTo(exploreTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(roundedBackgroundView)
            $0.height.equalTo(100)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(storyCollectionView.snp.bottom).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing).offset(-10)
        }
        
        postListTableView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(roundedBackgroundView)
            $0.bottom.equalTo(roundedBackgroundView)
        }
    }
    
    private func setupTableView() {
        postListTableView.register(
            PostListCell.self,
            forCellReuseIdentifier: PostListCell.reuseIdentifier
        )
        postListTableView.rowHeight = UITableView.automaticDimension
        postListTableView.estimatedRowHeight = 110
    }
    
    @objc
    private func showAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortLatestAction = UIAlertAction(
            title: "최신순",
            style: .default
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.sortButton.setImage(
                    UIImage.et_getImage(for: .sortImage_latest),
                    for: .normal
                )
            }
        }
        
        let sortViewsAction = UIAlertAction(
            title: "조회순",
            style: .default
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.sortButton.setImage(
                    UIImage.et_getImage(for: .sortImage_views),
                    for: .normal
                )
            }
        }
        
        let sortLikesAction = UIAlertAction(
            title: "추천순",
            style: .default
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.sortButton.setImage(
                    UIImage.et_getImage(for: .sortImage_likes),
                    for: .normal
                )
            }
        }
        
        alertController.addAction(sortLatestAction)
        alertController.addAction(sortViewsAction)
        alertController.addAction(sortLikesAction)
        
        self.present(
            alertController,
            animated: true
        )
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        return cell
    }
}
