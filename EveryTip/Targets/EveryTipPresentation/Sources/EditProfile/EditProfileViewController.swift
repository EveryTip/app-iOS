//
//  EditProfileViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/26/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

import ReactorKit
import RxSwift

final class EditProfileViewController: BaseViewController {
    
    weak var coordinator: EditProfileCoordinator?
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
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(.et_getImage(for: .blankImage), for: .normal)
        button.layer.cornerRadius = 45
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .et_pretendard(style: .semiBold, size: 23)
        label.textColor = .et_textColorBlack70
        
        return label
    }()
    
    private let optionTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: EditProfileReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubViews(
            roundedBackgroundView
        )
        
        roundedBackgroundView.addSubViews(
            profileImageButton,
            nickNameLabel,
            optionTableView
        )
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(51)
            $0.width.height.equalTo(90)
            $0.centerX.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        optionTableView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        optionTableView.register(
            MyInfoTableViewCell.self,
            forCellReuseIdentifier: MyInfoTableViewCell.reuseIdentifier
        )
        optionTableView.isScrollEnabled = false
    }
    
    private func showDeleteAccountAlert(reactor: EditProfileReactor) {
        let alert = UIAlertController(
            title: "회원 탈퇴",
            message: "정말로 에브리 팁을 탈퇴하시겠어요?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
            reactor.action.onNext(.deleteAccount)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}

extension EditProfileViewController: View {
    func bind(reactor: EditProfileReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: EditProfileReactor) {
        
        optionTableView.rx.itemSelected
            .map { Reactor.Action.itemSelected($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .map{ Reactor.Action.EditProfileImageTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: EditProfileReactor) {
        reactor.state
            .map { $0.options }
            .bind(to: optionTableView.rx.items(
                cellIdentifier: MyInfoTableViewCell.reuseIdentifier,
                cellType: MyInfoTableViewCell.self)
            ) { row, item, cell in
                switch item {
                case .changePassword:
                    cell.leftLabel.text = "비밀번호 변경"
                    cell.accessoryType = .disclosureIndicator
                case .manageBlockedUser:
                    cell.leftLabel.text = "차단 유저 관리"
                    cell.accessoryType = .disclosureIndicator
                case .deleteAccount:
                    cell.leftLabel.text = "회원 탈퇴"
                    cell.leftLabel.textColor = .red
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$changePasswordSignal)
            .filter { $0 == true }
            .bind { [weak self] _ in
                self?.coordinator?.pushToEditPassword()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$manageBlockedUserSignal)
            .filter { $0 == true }
            .bind { [weak self] _ in
                self?.coordinator?.pushToBlockedList()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$deleteAccountSignal)
            .filter { $0 == true }
            .bind { [weak self] _ in
                self?.showDeleteAccountAlert(reactor: reactor)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] message in
                print(message)
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.nickName }
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$dismissSignal)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
                self?.coordinator?.popToRootView()
            })
            .disposed(by: disposeBag)
    }
}
