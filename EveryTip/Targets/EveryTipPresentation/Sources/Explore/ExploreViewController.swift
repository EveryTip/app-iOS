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
import ReactorKit
import RxCocoa
import RxSwift

final class ExploreViewController: BaseViewController, View {
    weak var coordinator: ExploreCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
    
    // TODO: 타이틀 변경 동적이게 변경
    
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
        button.tintColor = UIColor.et_textColorBlack10
        
        return button
    }()
    
    private let postListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        
        return tableView
    }()
    
    init(reactor: ExploreReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
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
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing).offset(-20)
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
    private func presentSortAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let actions: [(String, SortOptions)] = [
            ("최신순", .latest),
            ("조회순", .views),
            ("추천순", .likes)
        ]
        
        actions.forEach { title, option in
            let action = UIAlertAction(
                title: title,
                style: .default
            ) { [weak self] _ in
                self?.reactor?.action.onNext(.sortButtonTapped(option))
            }
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true)
    }
    
    // MARK: Reactor
    
    func bind(reactor: ExploreReactor) {
        bindInput(to: reactor)
        bindOutput(to: reactor)
    }
    
    private func bindInput(to reactor: ExploreReactor) {
        sortButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentSortAlert()
            }
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(to reactor: ExploreReactor) {
        reactor.state
            .map { $0.sortButtonImage }
            .distinctUntilChanged()
            .bind(to: sortButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stories }
            .bind(to: storyCollectionView.rx.items(
                cellIdentifier: StoryCollectionViewCell.reuseIdentifier,
                cellType: StoryCollectionViewCell.self)
            ) { index, data, cell in
                cell.userNameLabel.text = data.userName
                cell.profileImageView.image = data.userProfileIamge
            }
            .disposed(by: disposeBag)
    }
}
