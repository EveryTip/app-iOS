//
//  BlockedListViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import SnapKit

import RxSwift

final class BlockedListViewController: BaseViewController {
    weak var coordinator: BlockedListCoordinator?
    
    private let placeHolderView: UserContentPlaceholderView = {
        let view = UserContentPlaceholderView(type: .blockedUser)
        view.isHidden = true
        
        return view
    }()
    
    private let blockedListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            BlockedListTableViewCell.self,
            forCellReuseIdentifier: BlockedListTableViewCell.reuseIdentifier
        )
        return tableView
    }()
    
    private var blockedUserIds: [Int] = Array(BlockManager.blockedUserIds)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTableView()
        loadBlockedUsers()
    }
    
    private func setupLayout() {
        view.addSubViews(
            blockedListTableView,
            placeHolderView
        )
    }
    
    private func setupConstraints() {
        blockedListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        placeHolderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        blockedListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(blockedUserIds)
            .bind(to: blockedListTableView.rx.items(
                cellIdentifier: BlockedListTableViewCell.reuseIdentifier,
                cellType: BlockedListTableViewCell.self)
            ) { [weak self] row, userId, cell in
                guard let self = self else { return }
                cell.configure(userID: userId, at: row)
                cell.removeButtonTapped
                    .subscribe(onNext: { _ in
                        BlockManager.unblock(userId: userId)
                        self.loadBlockedUsers()
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func loadBlockedUsers() {
        blockedUserIds = Array(BlockManager.blockedUserIds)
        blockedListTableView.reloadData()
        placeHolderView.isHidden = !blockedUserIds.isEmpty
    }
}

extension BlockedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 // 필요에 맞게 조정
    }
}
