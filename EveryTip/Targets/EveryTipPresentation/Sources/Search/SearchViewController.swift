//
//  SearchViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

final class SearchViewController: BaseViewController {
    
    var disposeBag = DisposeBag()
    weak var coordinator: SearchCoordinator?
    
    // MARK: - Navigation (titleView)
    private let searchBarTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .et_lineGray20
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let searchBarTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = "어떤 팁이 궁금하세요?"
        textField.font = .et_pretendard(style: .medium, size: 16)
        textField.textColor = .et_textColorBlack70
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        
        let templatedImage = UIImage.et_getImage(for: .searchIcon).withRenderingMode(.alwaysTemplate)
        
        var config = UIButton.Configuration.plain()
        config.image = templatedImage
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 20)
        button.configuration = config
        button.tintColor = .et_brandColor2
        
        return button
    }()
    
    // MARK: - Content
    private let middleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let recentSearchLable: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .et_pretendard(style: .bold, size: 16)
        label.textColor = .et_textColorBlack90
        return label
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .medium, size: 16)
        button.tintColor = .et_textColorBlack10
        return button
    }()
    
    private let searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let sortButton: SortButton = {
        let button = SortButton(type: .system)
        button.configureButtonStyle(with: .latest)
        return button
    }()
    
    private let tipsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let placeholderView: UserContentPlaceholderView = {
        let view = UserContentPlaceholderView(type: .emptySearchResult)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Init
    init(reactor: SearchReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTableView()
        configureNavigationItemForSearch()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        // titleView는 navigationItem에 올리므로 view 계층에는 추가하지 않음
        view.addSubViews(
            middleView,
            searchHistoryTableView,
            tipsTableView,
            placeholderView
        )
        
        middleView.addSubViews(
            recentSearchLable,
            removeAllButton,
            sortButton
        )
    }
    
    private func setupConstraints() {
        middleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(20)
        }
        
        recentSearchLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(middleView.snp.leading).offset(20)
        }
        
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(middleView.snp.trailing).offset(-20)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(middleView.snp.trailing).offset(-20)
        }
        
        searchHistoryTableView.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tipsTableView.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        placeholderView.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        searchHistoryTableView.register(
            SearchHistoryCell.self,
            forCellReuseIdentifier: SearchHistoryCell.reuseIdentifier
        )
        searchHistoryTableView.separatorStyle = .none
        
        tipsTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
    }
    
    // MARK: - NavigationItem (Search 전용)
    private func configureNavigationItemForSearch() {
        navigationItem.titleView = searchBarTextFieldView
        searchBarTextFieldView.addSubview(searchBarTextField)
        searchBarTextField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 10,
                    left: 12,
                    bottom: 10,
                    right: 12
                )
            )
        }
        searchBarTextFieldView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(270)
            $0.height.equalTo(40)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
}

// MARK: - ReactorKit
extension SearchViewController: View {
    func bind(reactor: SearchReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: SearchReactor) {
        // 검색어 변경
        searchBarTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.keywordInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 오른쪽 바 버튼(검색) 탭
        searchButton.rx.tap
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 키보드 리턴 (검색)
        searchBarTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 진입 시 최근 키워드 로드
        Observable.just(())
            .map { Reactor.Action.loadRecentKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 전체 삭제
        removeAllButton.rx.tap
            .map { Reactor.Action.removeAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 팁 선택
        tipsTableView.rx.itemSelected
            .map { Reactor.Action.tipSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 정렬 버튼 (액션 시트)
        sortButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentSortAlert { selectedOption in
                    self?.reactor?.action.onNext(.sortButtonTapped(selectedOption))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: SearchReactor) {
        // 최근 검색어 목록
        reactor.state
            .map(\.recentKeywords)
            .distinctUntilChanged()
            .bind(to: searchHistoryTableView.rx.items(
                cellIdentifier: SearchHistoryCell.reuseIdentifier,
                cellType: SearchHistoryCell.self
            )) { _, keyword, cell in
                cell.configureCell(with: keyword)
                cell.removeButtonTapped
                    .subscribe(onNext: { [weak self] in
                        self?.reactor?.action.onNext(.removeRecentKeyword(keyword))
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 최근 검색어 탭 → 검색어 반영
        searchHistoryTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] keyword in
                self?.searchBarTextField.text = keyword
                reactor.action.onNext(.keywordInputChanged(keyword))
            })
            .disposed(by: disposeBag)
        
        // 토스트
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        // 검색 전후 상태에 따른 영역 토글
        reactor.state
            .map(\.isSearched)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isSearched in
                self?.recentSearchLable.isHidden = isSearched
                self?.removeAllButton.isHidden = isSearched
                self?.searchHistoryTableView.isHidden = isSearched
                
                self?.sortButton.isHidden = !isSearched
                self?.tipsTableView.isHidden = !isSearched
            })
            .disposed(by: disposeBag)
        
        // 팁 목록
        reactor.state
            .map(\.tips)
            .bind(to: tipsTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self
            )) { _, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        // 빈 결과 플레이스홀더 처리
        Observable
            .combineLatest(
                reactor.state.map(\.isSearched).distinctUntilChanged(),
                reactor.state.map(\.tips)
            )
            .map { isSearched, tips in
                return isSearched && tips.isEmpty
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] shouldShowPlaceholder in
                self?.placeholderView.isHidden = !shouldShowPlaceholder
            })
            .disposed(by: disposeBag)
        
        // 닫기
        reactor.pulse(\.$dismissSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.popView()
            })
            .disposed(by: disposeBag)
        
        // 상세 푸시
        reactor.pulse(\.$pushSignal)
            .filter { $0 }
            .withUnretained(self)
            .bind { viewController, _ in
                guard let tip = viewController.reactor?.currentState.selectedTip else { return }
                viewController.coordinator?.pushToTipDetailView(with: tip.id)
            }
            .disposed(by: disposeBag)
        
        // 정렬 버튼 스타일 갱신
        reactor.state
            .map(\.sortOption)
            .distinctUntilChanged()
            .bind { [weak self] sortOption in
                self?.sortButton.configureButtonStyle(with: sortOption)
            }
            .disposed(by: disposeBag)
    }
}
