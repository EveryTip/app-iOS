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
    
    //MARK: Search View Items
    
    private let searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        
        return view
    }()
    
    private let searchBar: UIButton = {
        let searchBar = UIButton()
        searchBar.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        
        return searchBar
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1.00)
        
        return imageView
    }()
    
    //MARK: Tag ScrollView Items
    
    // 스크롤 뷰 점점 사라지는 그라데이션 효과 제공
    private let gradientMaskView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let tagButtonsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    private let tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let tagButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    //MARK: TableView Items
    
    private let tableViewBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
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
    
    // 레이아웃 편의와 전체적인 높이 컨트롤을 위한 투명 뷰
    private let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
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
        setupTags()
    }
    
    override func viewDidLayoutSubviews() {
        applyGradientMask()
    }
    
    private func setupLayout() {
        view.addSubview(weeklyTipLabel)
        view.addSubview(weeklyTipImageView)
        view.addSubview(weeklyTipLearnMoreButton)
        
        view.addSubview(searchView)
        searchBar.addSubview(searchIcon)
        searchView.addSubview(searchBar)
        searchView.addSubview(gradientMaskView)
        
        gradientMaskView.addSubview(tagButtonsScrollView)
        tagButtonsScrollView.addSubview(tagsStackView)
        
        view.addSubview(spacer)
        
        headerView.addSubview(popularTipLabel)
        headerView.addSubview(popularTipLearnMoreButton)
        
        view.addSubview(tableViewBackgroundView)
        view.addSubview(postListTableView)
    }
    
    private func setupConstraints() {
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
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(weeklyTipImageView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(searchBar.snp.height).offset(50)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.top).offset(5)
            $0.leading.equalTo(searchView.snp.leading).offset(15)
            $0.trailing.equalTo(searchView.snp.trailing).offset(-15)
        }
        
        searchIcon.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.top).offset(5)
            $0.trailing.equalTo(searchBar.snp.trailing).offset(-10)
            $0.bottom.equalTo(searchBar.snp.bottom).offset(-5)
        }
        
        gradientMaskView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.leading.equalTo(searchView.snp.leading).offset(15)
            $0.trailing.equalTo(searchView.snp.trailing).offset(-15)
            $0.bottom.equalTo(searchView.snp.bottom)
            $0.height.equalTo(40)
        }
        
        tagButtonsScrollView.snp.makeConstraints {
            $0.edges.equalTo(gradientMaskView)
        }
        
        tagsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popularTipLabel.snp.makeConstraints {
            $0.leading.equalTo(headerView)
            $0.centerY.equalToSuperview()
        }
        
        popularTipLearnMoreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(headerView)
        }
        
        spacer.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(20)
        }
        
        tableViewBackgroundView.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        postListTableView.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        postListTableView.register(PostListCell.self, forCellReuseIdentifier: PostListCell.reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        postListTableView.tableHeaderView = headerView
        postListTableView.rowHeight = UITableView.automaticDimension
        postListTableView.estimatedRowHeight = 110
    }
    
    private func setupTags() {
        let tags = ["#햄버거", "#치킨", "#피자","#햄버거", "#치킨", "#피자","#햄버거", "#치킨", "#피자","#햄버거", "#치킨", "#피자",]
        for tag in tags {
            let button = UIButton(type: .system)
            button.setTitle(" \(tag) ", for: .normal)
            
            button.setTitleColor(.et_textColorBlack10, for: .normal)
            button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
            button.layer.cornerRadius = 10
            tagsStackView.addArrangedSubview(button)
        }
    }
    
    // TODO: 동작 방식 개선
    
    private func addSpace(forTitleLength length: Int) -> String {
        if length <= 2 {
            return String(repeating: "     ", count: length)
        }
        return String(repeating: "    ", count: length)
    }
    
    // 태그 스크롤뷰의 그라데이션을 적용하는 메서드
    private func applyGradientMask() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientMaskView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.5)
        
        gradientMaskView.layer.mask = gradientLayer
    }
}

//MARK: Reactor

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        bindInputs(to: reactor)
        bindOutputs(to: reactor)
    }
    
    private func bindInputs(to reactor: HomeReactor) {
        self.reactor?.action.onNext(.viewDidLoad)
        
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
                cell.categoryLabel.text = " \(post.category) "
                cell.titleLabel.text = "\(self.addSpace(forTitleLength: post.category.count) + post.title)  "
                cell.mainTextLabel.text = post.mainText
                cell.userNameLabel.text = post.userName
                cell.likeCountLabel.text = "\(post.likeCount)"
                cell.viewCountLabel.text = "\(post.viewCount)"
                //            // TODO: 이미지 url을 통한 패칭 적용
                //            //            cell.thumbnailImageView.image = UIImage(data: <#T##Data#>)
                
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
