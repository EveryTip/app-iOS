//
//  CategoryViewController.swift
//  EveryTip
//
//  Created by 김경록 on 7/4/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import RxSwift

final class CategoryViewController: BaseViewController {
    
    weak var coordinator: CategoryViewCoordinator?
    
    // TODO: 상수 파일로 분리
    
    private let categories: [TipCategory] = [
        .hobby,
        .it,
        .health,
        .finance,
        .entertainment,
        .sports,
        .games,
        .social
    ]
    
    private let bannerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 카테고리"
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 22
        )
        label.textColor = .white
        
        return label
    }()
    
    private let bannerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 카테고리를 선택하시면\n관련 팁을 보여드릴게요."
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .categoryViewBanner)
        
        return imageView
    }()
    
    private let tableViewBackGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        
        return view
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupTableView() {
        categoryTableView.register(
            CategoryCell.self,
            forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(bannerTitleLabel)
        view.addSubview(bannerDescriptionLabel)
        view.addSubview(bannerImageView)
        
        tableViewBackGroundView.addSubview(categoryTableView)
        view.addSubview(tableViewBackGroundView)
    }
    
    private func setupConstraints() {
        bannerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(bannerImageView.snp.leading)
        }
        
        bannerDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bannerTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(bannerImageView.snp.leading)
        }
        
        bannerImageView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width).multipliedBy(0.22)
            $0.height.equalTo(bannerImageView.snp.width)
            
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        tableViewBackGroundView.snp.makeConstraints {
            $0.top.equalTo(bannerDescriptionLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        categoryTableView.snp.makeConstraints {
            $0.top.equalTo(tableViewBackGroundView.snp.top).offset(10)
            $0.leading.trailing.equalTo(tableViewBackGroundView).inset(10)
            $0.bottom.equalTo(tableViewBackGroundView.snp.bottom)
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(
            withIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCell else { return
            UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.configure(
            image: category.image,
            color: category.color,
            title: category.title
        )
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    
}
