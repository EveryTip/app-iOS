//
//  MyInfoViewController.swift
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

final class MyInfoViewController: BaseViewController {

    // MARK: - Dependencies
    weak var coordinator: MyInfoViewCoordinator?
    var disposeBag = DisposeBag()

    // MARK: - Relays
    private let logoutConfirmTapped = PublishRelay<Void>()
    private let tapGesture = UITapGestureRecognizer()

    // MARK: - UI
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
        let iv = UIImageView()
        iv.image = UIImage.et_getImage(for: .blankImage)
        iv.backgroundColor = .gray
        return iv
    }()

    private let userNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .semiBold, size: 22)
        return label
    }()

    private let subscribersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자 0"
        return label
    }()

    private let postedTipCountLabel: UILabel = {
        let label = UILabel()
        label.text = "작성 팁 0"
        return label
    }()

    private let savedTipCountLabel: UILabel = {
        let label = UILabel()
        label.text = "저장 팁 0"
        return label
    }()

    private let touchableView = UIView()

    private let nextButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .et_getImage(for: .nextButton_darkGray)
        return iv
    }()

    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .edit)
        configuration.attributedTitle = AttributedString(
            "프로필 편집",
            attributes: AttributeContainer([.font: UIFont.et_pretendard(style: .bold, size: 14)])
        )
        configuration.imagePadding = 8
        configuration.baseForegroundColor = .et_textColorBlack50
        configuration.background.backgroundColor = .et_lineGray20
        button.configuration = configuration
        button.layer.cornerRadius = 5
        return button
    }()

    private let userInfoTableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = true
        return tv
    }()

    // MARK: - Init
    init(reactor: MyInfoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setTableView()
        setUserInteraction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.makeCircular()
    }

    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubViews(
            userImageView,
            userNameLable,
            touchableView,
            editProfileButton,
            userInfoTableView
        )

        touchableView.addSubViews(
            subscribersCountLabel,
            postedTipCountLabel,
            savedTipCountLabel,
            nextButtonImageView
        )
    }

    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
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

        touchableView.snp.makeConstraints {
            $0.top.equalTo(userNameLable.snp.bottom).offset(5)
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing).offset(-10)
            $0.height.equalTo(20)
        }

        subscribersCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(touchableView)
        }

        postedTipCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(subscribersCountLabel.snp.trailing).offset(12)
        }

        savedTipCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(postedTipCountLabel.snp.trailing).offset(12)
        }

        nextButtonImageView.snp.makeConstraints {
            $0.width.equalTo(4)
            $0.height.equalTo(8)
            $0.centerY.equalTo(touchableView)
            $0.leading.equalTo(savedTipCountLabel.snp.trailing).offset(12)
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
        userInfoTableView.dataSource = self
        userInfoTableView.register(
            MyInfoTableViewCell.self,
            forCellReuseIdentifier: MyInfoTableViewCell.reuseIdentifier
        )
    }

    private func setUserInteraction() {
        touchableView.addGestureRecognizer(tapGesture)
    }

    private func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "로그아웃 하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.logoutConfirmTapped.accept(())
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .default)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reactor?.currentState.items.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = userInfoTableView.dequeueReusableCell(
                withIdentifier: MyInfoTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? MyInfoTableViewCell,
            let reactor = reactor,
            indexPath.row < reactor.currentState.items.count
        else {
            return UITableViewCell()
        }

        let item = reactor.currentState.items[indexPath.row]

        cell.selectionStyle = .default
        cell.leftLabel.text = item.title
        cell.rightLabel.text = nil
        cell.accessoryType = .none

        switch item {
        case .setSubscribe, .setCategories, .agreement:
            cell.accessoryType = .disclosureIndicator
        case .version(let versionString):
            cell.rightLabel.text = versionString
        case .login, .logout:
            break
        }

        return cell
    }
}

// MARK: - Reactor View
extension MyInfoViewController: View {
    func bind(reactor: MyInfoReactor) {
        bindInputs(to: reactor)
        bindOutputs(to: reactor)
    }

    private func bindInputs(to reactor: MyInfoReactor) {
        // 최신 상태 동기화를 위해 화면 표시 시점에만 refresh
        rx.viewWillAppear
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.userDidLogout)
            .map { _ in Reactor.Action.applyGuestProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.coordinator?.checkLoginBeforeAction(onLoggedIn: { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.pushToUserContentsView(myID: reactor.currentState.myProfile.id)
                })
            }
            .disposed(by: disposeBag)

        logoutConfirmTapped
            .map { Reactor.Action.logoutConfirmTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        userInfoTableView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.userInfoTableView.deselectRow(at: indexPath, animated: true)
            })
            .map { indexPath -> MyInfoReactor.InfoTableViewItem in
                reactor.currentState.items[indexPath.row]
            }
            .map { item -> MyInfoReactor.Action? in
                switch item {
                case .setSubscribe:  return .setSubscribeButtonTapped
                case .setCategories: return .setCategoryButtonTapped
                case .agreement:     return .agreementCellTapped
                case .login:         return .loginCellTapped
                case .logout:        return .logoutCellTapped
                case .version:       return nil
                }
            }
            .compactMap { $0 }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        editProfileButton.rx.tap
            .map { Reactor.Action.editProfileButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindOutputs(to reactor: MyInfoReactor) {
        reactor.state.map { $0.myProfile.nickName }
            .distinctUntilChanged()
            .bind(to: userNameLable.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.items)
            .distinctUntilChanged { $0 == $1 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                self?.userInfoTableView.reloadData()
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.myProfile.subscriberCount }
            .distinctUntilChanged()
            .bind(with: self) { owner, count in
                owner.subscribersCountLabel.setCountLabelStyle(
                    normalText: "구독자 ",
                    boldText: count.toAbbreviatedString()
                )
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.myProfile.tipCount }
            .distinctUntilChanged()
            .bind(with: self) { owner, count in
                owner.postedTipCountLabel.setCountLabelStyle(
                    normalText: "작성 팁 ",
                    boldText: count.toAbbreviatedString()
                )
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.myProfile.savedTipCount }
            .distinctUntilChanged()
            .bind(with: self) { owner, count in
                owner.savedTipCountLabel.setCountLabelStyle(
                    normalText: "저장 팁 ",
                    boldText: count.toAbbreviatedString()
                )
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$navigationSignal)
            .compactMap { $0 }
            .bind(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .agreement:
                    self.coordinator?.pushToAgreementViewcontroller()
                case .logout:
                    self.showLogoutAlert()
                case .userContents:
                    self.coordinator?.checkLoginBeforeAction {
                        self.coordinator?.pushToUserContentsView(myID: reactor.currentState.myProfile.id)
                    }
                case .editProfile:
                    self.coordinator?.checkLoginBeforeAction {
                        self.coordinator?.pushToEditProfileView(myNickName: reactor.currentState.myProfile.nickName)
                    }
                case .setCategories:
                    self.coordinator?.checkLoginBeforeAction {
                        self.coordinator?.pushToSetCategory()
                    }
                case .setSubscribe:
                    self.coordinator?.checkLoginBeforeAction {
                        self.coordinator?.pushToUserContentsView(myID: reactor.currentState.myProfile.id)
                    }
                case .login:
                    self.coordinator?.pushToLoginView()
                }
            })
            .disposed(by: disposeBag)
    }
}
