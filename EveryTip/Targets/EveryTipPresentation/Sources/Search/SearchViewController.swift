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
    
    private let naviBarView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .backButton), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let searchBarTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .et_lineGray20
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    private let searchBarTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .et_lineGray20
        tf.placeholder = "어떤 팁이 궁금하세요?"
        tf.font = .et_pretendard(style: .medium, size: 16)
        tf.textColor = .et_textColorBlack70
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .searchIcon), for: .normal)
        button.tintColor = .et_brandColor2
        
        return button
    }()
    
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
        button.titleLabel?.font = .et_pretendard(
            style: .medium,
            size: 16
        )
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
    
    init(reactor: SearchReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTableView()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupLayout() {
        view.addSubViews(
            naviBarView,
            middleView,
            searchHistoryTableView,
            tipsTableView,
            placeholderView
        )
        searchBarTextFieldView.addSubview(
            searchBarTextField
        )
        
        middleView.addSubViews(
            recentSearchLable,
            removeAllButton,
            sortButton
        )
        
        naviBarView.addSubViews(
            backButton,
            searchBarTextFieldView,
            searchButton
        )
    }
    
    private func setupConstraints() {
        naviBarView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalTo(naviBarView.snp.leading).offset(20)
            $0.height.equalTo(16)
            $0.width.equalTo(8)
            $0.centerY.equalTo(naviBarView)
        }
        
        searchBarTextFieldView.snp.makeConstraints {
            $0.width.equalTo(264)
            $0.height.equalTo(40)
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.centerY.equalTo(naviBarView)
        }
        
        searchBarTextField.snp.makeConstraints {
            $0.leading.equalTo(searchBarTextFieldView.snp.leading).offset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(naviBarView.snp.trailing).offset(-25)
            $0.centerY.equalTo(naviBarView)
            $0.height.width.equalTo(18)
        }
        
        middleView.snp.makeConstraints {
            $0.top.equalTo(naviBarView.snp.bottom).offset(20)
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
}

extension SearchViewController: View {
    func bind(reactor: SearchReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    func bindInput(reactor: SearchReactor) {
        searchBarTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.keywordInputChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .map { Reactor.Action.searchButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.loadRecentKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeAllButton.rx.tap
            .map { Reactor.Action.removeAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipsTableView.rx.itemSelected
            .map{Reactor.Action.tipSelected($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentSortAlert { selectedOption in
                    self?.reactor?.action.onNext(.sortButtonTapped(selectedOption))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: SearchReactor) {
        reactor.state
            .map(\.recentKeywords)
            .distinctUntilChanged()
            .bind(to: searchHistoryTableView.rx.items(
                cellIdentifier: SearchHistoryCell.reuseIdentifier,
                cellType: SearchHistoryCell.self
            )) { index, keyword, cell in
                cell.configureCell(with: keyword)
                cell.removeButtonTapped
                    .subscribe(onNext: { [weak self] in
                        self?.reactor?.action.onNext(.removeRecentKeyword(keyword))
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        searchHistoryTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] keyword in
                self?.searchBarTextField.text = keyword
                reactor.action.onNext(.keywordInputChanged(keyword))
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] msg in
                self?.showToast(message: msg)
            })
            .disposed(by: disposeBag)
        
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
        
        reactor.state
            .map(\.tips)
            .bind(to: tipsTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self
            )) { index, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
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
        
        
        reactor.pulse(\.$dismissSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.popView()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                guard let tip = vc.reactor?.currentState.selectedTip else {
                    return
                }
                vc.coordinator?.pushToTipDetailView(with: tip.id)
               
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sortOption }
            .distinctUntilChanged()
            .bind { [weak self] sortOption in
                guard let self = self else { return }
                self.sortButton.configureButtonStyle(with: sortOption)
            }
            .disposed(by: disposeBag)
    }
}
