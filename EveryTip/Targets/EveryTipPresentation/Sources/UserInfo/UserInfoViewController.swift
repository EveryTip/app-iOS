//
//  UserInfoViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class UserInfoViewController: BaseViewController {
    
    weak var coordinator: UserInfoViewCoordinator?
    var disposeBag = DisposeBag()
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
        
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .blankImage)
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    private let userNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 22
        )
        label.text = "고앵이"
        
        return label
    }()
    
    private let subscribersLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자"
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        
        return label
    }()
    
    private let subscribersCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 14
        )
        
        return label
    }()
    
    private lazy var subscribersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let postedTipLabel: UILabel = {
        let label = UILabel()
        label.text = "작성 팁"
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        
        return label
    }()
    
    private let postedTipCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 14
        )
        
        return label
    }()
    
    private lazy var postedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let savedTipLabel: UILabel = {
        let label = UILabel()
        label.text = "저장 팁"
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        
        return label
    }()
    
    private let savedTipCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 14
        )
        
        return label
    }()
    
    private lazy var savedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let touchableStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = true
        
        return stackView
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 편집", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        button.backgroundColor = UIColor.et_lineGray20
        button.tintColor = UIColor.et_textColorBlack50
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    private let userInfoTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: UserInfoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.makeCircular()
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setTableView()
        setUserInteraction()
    }
    
    //MARK: Private Methods
    
    private func setupLayout() {
        view.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(userImageView)
        roundedBackgroundView.addSubview(userNameLable)
        
        roundedBackgroundView.addSubview(subscribersStackView)
        subscribersStackView.addArrangedSubview(subscribersLabel)
        subscribersStackView.addArrangedSubview(subscribersCountLabel)
        
        roundedBackgroundView.addSubview(postedStackView)
        postedStackView.addArrangedSubview(postedTipLabel)
        postedStackView.addArrangedSubview(postedTipCountLabel)
        
        roundedBackgroundView.addSubview(savedStackView)
        savedStackView.addArrangedSubview(savedTipLabel)
        savedStackView.addArrangedSubview(savedTipCountLabel)
        
        roundedBackgroundView.addSubview(touchableStackView)
        touchableStackView.addArrangedSubview(subscribersStackView)
        touchableStackView.addArrangedSubview(postedStackView)
        touchableStackView.addArrangedSubview(savedStackView)
        
        roundedBackgroundView.addSubview(editProfileButton)
        roundedBackgroundView.addSubview(userInfoTableView)
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(30)
            $0.leading.equalTo(roundedBackgroundView.snp.leading).offset(20)
            $0.width.height.equalTo(60)
        }
        
        userNameLable.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(35)
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing)
        }
        
        touchableStackView.snp.makeConstraints {
            $0.top.equalTo(userNameLable.snp.bottom).offset(5)
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.trailing.lessThanOrEqualTo(roundedBackgroundView.snp.trailing).offset(-10)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(120)
            $0.leading.trailing.equalTo(roundedBackgroundView).inset(20)
        }
        
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(editProfileButton.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(roundedBackgroundView)
        }
    }
    
    private func setTableView() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        userInfoTableView.register(
            UserInfoTableViewCell.self,
            forCellReuseIdentifier: UserInfoTableViewCell.reuseIdentifier
        )
    }
    
    private func setUserInteraction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(navigationToUserContentsView)
        )
        touchableStackView.addGestureRecognizer(tapGesture)
    }
    
    // TODO: 리액터로 처리하도록 변경
    @objc
    private func navigationToUserContentsView() {
        coordinator?.checkLoginBeforeAction(onLoggedIn: { [weak self] in
            self?.coordinator?.pushToUserContentsView()
        })
        
//        print(reactor?.currentState.userInfo)
    }
    
    private func navigationToAgreementView() {
        coordinator?.pushToAgreementViewcontroller()
    }
 
    private func toTestSignInView() {
        let testSignInVC = TestSignInViewController()
        coordinator?.navigationController.pushViewController(testSignInVC, animated: true)
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4: navigationToAgreementView()
        case 6: toTestSignInView()
        default:
            return
        }
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        
        return reactor.getInfoTableViewItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userInfoTableView.dequeueReusableCell(
            withIdentifier: UserInfoTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? UserInfoTableViewCell else { return
            UITableViewCell()
        }
        
        cell.leftLabel.text = reactor?.getInfoTableViewItems()[indexPath.row]
        
        switch indexPath.row {
        case 0...4:
            cell.accessoryType = .disclosureIndicator
            cell.rightLabel.text = nil
        case 5:
            // TODO: 버전정보 및 공지사항등 api 연결
            cell.accessoryType = .none
            cell.rightLabel.text = "1.01"
        default:
            cell.accessoryType = .none
            cell.rightLabel.text = nil
        }
        
        return cell
    }
}

//MARK: Reactor

extension UserInfoViewController: View {
    func bind(reactor: UserInfoReactor) {
        bindInputs(to: reactor)
        bindOutputs(to: reactor)
    }
    
    private func bindInputs(to reactor: UserInfoReactor) {
        self.reactor?.action.onNext(.viewDidLoad)
    }
    
    private func bindOutputs(to reactor: UserInfoReactor) {
        reactor.state.map { $0.userName }
            .bind(to: userNameLable.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.subscribersCount }
        .bind(to: subscribersCountLabel.rx.text)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.postedTipCount }
        .bind(to: postedTipCountLabel.rx.text)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.savedTipCount }
        .bind(to: savedTipCountLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
