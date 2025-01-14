//
//  HomeViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class HomeViewController: BaseViewController {
    
    weak var coordinator: HomeViewCoordinator?
    
    var disposeBag = DisposeBag()
    
    init(reactor: HomeReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: WeeklyTip Items
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
    
    private let weeklyTipLabel: UILabel = {
        let label = UILabel()
        label.text = "코끼리는 유일하게 OO를\n하지 못하는 포유류입니다 "
        label.textColor = .white
        label.font = UIFont.et_pretendard(
            style: .extraBold,
            size: 18
        )
        
        label.numberOfLines = 0
        
        return label
    }()
    
    private let weeklyTipLearnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("자세히 보기 >", for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let weeklyTipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .homeViewEmoji)
        
        return imageView
    }()
    
    private let searchBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "#F6F6F6")
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .searchIcon)
        
        return imageView
    }()
    
    // TODO: 추가 Section 정의
    
    private let headerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let popularTipLabel: UILabel = {
        let label = UILabel()
        label.text = "인기 팁 모아보기 🔥"
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 18
        )
        
        return label
    }()
    
    private let popularTipLearnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.et_textColorBlack10, for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        return button
    }()
    
    private let postListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    //MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(weeklyTipLabel)
        view.addSubview(weeklyTipImageView)
        view.addSubview(weeklyTipLearnMoreButton)
        view.addSubview(roundedBackgroundView)
        
        headerView.addSubview(popularTipLabel)
        headerView.addSubview(popularTipLearnMoreButton)
        roundedBackgroundView.addSubview(searchBarButton)
        searchBarButton.addSubview(searchIcon)
        roundedBackgroundView.addSubview(postListTableView)
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(weeklyTipImageView.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalTo(view)
        }
        
        weeklyTipLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        weeklyTipLearnMoreButton.snp.makeConstraints {
            $0.top.equalTo(weeklyTipLabel.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        weeklyTipImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.width.equalTo(view.snp.width).multipliedBy(0.29)
            $0.height.equalTo(weeklyTipImageView.snp.width).multipliedBy(0.955)
        }
        
        popularTipLabel.snp.makeConstraints {
            $0.leading.equalTo(headerView)
            $0.centerY.equalToSuperview()
        }
        
        popularTipLearnMoreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(headerView)
        }
        
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(12)
            $0.leading.equalTo(roundedBackgroundView).offset(15)
            $0.trailing.equalTo(roundedBackgroundView).offset(-15)
            $0.height.equalTo(40)
        }
        
        searchIcon.snp.makeConstraints {
            $0.top.equalTo(searchBarButton).offset(11)
            $0.bottom.equalTo(searchBarButton).offset(-11)
            $0.trailing.equalTo(searchBarButton.snp.trailing).offset(-11)
        }
        
        postListTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(20)
            $0.leading.equalTo(roundedBackgroundView).offset(15)
            $0.trailing.equalTo(roundedBackgroundView).offset(-15)
            $0.bottom.equalTo(roundedBackgroundView)
        }
    }
    
    private func setupTableView() {
        postListTableView.register(PostListCell.self, forCellReuseIdentifier: PostListCell.reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        postListTableView.tableHeaderView = headerView
        postListTableView.rowHeight = UITableView.automaticDimension
        postListTableView.estimatedRowHeight = 130
    }
}

//MARK: Reactor

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        bindInputs(to: reactor)
        bindOutputs(to: reactor)
    }
    
    private func bindInputs(to reactor: HomeReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        postListTableView.rx.itemSelected
            .map{Reactor.Action.itemSeleted($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs(to reactor: HomeReactor) {
        reactor.state.map { $0.posts }
            .bind(
                to: postListTableView.rx.items(
                    cellIdentifier: PostListCell.reuseIdentifier,
                    cellType: PostListCell.self
                )
            ) { index, post, cell in
                cell.mainTextLabel.text = post.mainText
                cell.userNameLabel.text = "by \(post.userName)"
                // TODO: API 확정시 entity 변경후 수정
                // categoryLabel, titleLabel 의 경우 configure 메서드로 호출 및 순서 준수 필요
                cell.configureCategoryLabel(id: 1)
                cell.configureTitleLabelText(post.title)
                
                // 각 count 계수는 toAbbreviatedString로 파싱해서 사용 할 것
                cell.viewsCountLabel.text = "\(post.viewCount.toAbbreviatedString())"
                // TODO: API에 코멘트 개수 추가 필요
                // cell.commentsCountLabel.text = "\(post.viewCount.toAbbreviatedString())"
                cell.likesCountLabel.text = "\(post.likeCount.toAbbreviatedString())"
                
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.fetchError }
            .subscribe(onNext: { error in
                if let error = error {
                    print("Error: \(error)")
                    // 에러 핸들링 로직 추가 (예: Alert 표시)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedItem }
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] tip in
                self?.coordinator?.navigateToTestView(with: tip)
            })
            .disposed(by: disposeBag)
    }
}
