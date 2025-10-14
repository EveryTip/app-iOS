//
//  TipDetailViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem
import EveryTipCore

import SnapKit
import ReactorKit
import RxSwift
import Kingfisher

final class TipDetailViewController: BaseViewController {
    weak var coordinator: TipDetailCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    enum EllipsisButtonType {
        case tip
        case comment
    }
    
    enum EllipsisButtonActionType {
        case report
        case delete
    }
    
    private let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // MARK: 작성자
    private let writerTapGesture = UITapGestureRecognizer()
    
    private let writerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let writerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .blankImage)
        
        return imageView
    }()
    
    private let writerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .semiBold, size: 14)
        label.textColor = .et_textColorBlack70
        
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let postWrittenTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let viewsImageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage.et_getImage(for: .viewsImage)
        
        return imageView
    }()
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let lineSeparator: StraightLineView = {
        let line = StraightLineView(color: UIColor.et_lineGray30)
        
        return line
    }()
    
    private let tipView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .semiBold, size: 20)
        label.textColor = .et_textColorBlack90
        
        return label
    }()
    
    private let mainTexLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .regular, size: 16)
        label.textColor = .et_textColorBlack70
        label.numberOfLines = 0
        
        return label
    }()
    
    private let tipImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 70)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()
    
    
    private let tagsCollectionView: UICollectionView = {
        let tagStyleLayout = TagStyleFlowLayout()
        tagStyleLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagStyleLayout.minimumInteritemSpacing = 6
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: tagStyleLayout
        )
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let socialView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 27
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let likeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let saveButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .bookmark)
        configuration.imagePadding = 6
        
        let attributedTitle = AttributedString(
            "팁 저장",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .et_lineGray20
        
        return view
    }()
    
    private let commentInfoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .bold, size: 16)
        
        return label
    }()
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let commentInputBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.et_lineGray30.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let commentPlaceholderLable: UILabel = {
        let label = UILabel()
        label.text = "유용한 답변으로 팁 좋아요를 받아보세요 :)"
        label.font = .et_pretendard(style: .bold, size: 14)
        label.textColor = .et_textColor5
        
        return label
    }()
    
    private let commentInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .et_pretendard(style: .bold, size: 14)
        textView.textColor = .et_textColorBlack70
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    private let submitCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("입력", for: .normal)
        button.backgroundColor = .et_brandColor2
        button.layer.cornerRadius = 5
        button.tintColor = .white
        button.clipsToBounds = true
        
        return button
    }()
    
    init(reactor: TipDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTagCollectionView()
        setupCommentTableView()
        setupImageCollectionView()
        commentInputTextView.delegate = self
        navigationItem.rightBarButtonItem = rightButtonItem
        setupGesture()
    }
    
    private let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(.et_getImage(for: .ellipsis_black), for: .normal)
        
        button.tintColor = .et_textColorBlack90
        
        return button
    }()
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(customView: ellipsisButton)
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        writerImageView.makeCircular()
        
        let height = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        tagsCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        let imageCount = reactor?.currentState.tip?.images.count ?? 0
        
        tipImageCollectionView.snp.updateConstraints {
            $0.height.equalTo(imageCount == 0 ? 0 : 70)
        }
        
        updateTableViewHeight()
    }
    
    private func setupImageCollectionView() {
        tipImageCollectionView.register(
            TipPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: TipPhotoCollectionViewCell.reuseIdentifier
        )
    }
    
    private func setupTagCollectionView() {
        tagsCollectionView.register(
            TagCollectionViewCell.self,
            forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier
        )
    }
    
    private func setupCommentTableView() {
        commentTableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier
        )
        
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 78
        commentTableView.separatorStyle = .none
        commentTableView.isScrollEnabled = false
    }
    
    private func setupLayout() {
        view.addSubViews(
            backgroundScrollView,
            commentInputBackgroundView
        )
        
        backgroundScrollView.addSubview(contentView)
        
        contentView.addSubViews(
            writerView,
            lineSeparator,
            tipView,
            bottomSeparator,
            commentInfoView,
            commentTableView
        )
        
        commentInputTextView.addSubViews(commentPlaceholderLable)
        
        commentInputBackgroundView.addSubViews(
            commentInputTextView,
            submitCommentButton
        )
        
        writerView.addSubViews(
            writerImageView,
            writerNameLabel,
            categoryLabel,
            postWrittenTimeLabel,
            viewsImageView,
            viewsCountLabel
        )
        
        tipView.addSubViews(
            titleLabel,
            mainTexLabel,
            tipImageCollectionView,
            tagsCollectionView,
            socialView
        )
        
        socialView.addArrangedSubViews(
            likeButton,
            saveButton
        )
        
        commentInfoView.addSubViews(
            commentCountLabel
        )
    }
    
    private func updateTableViewHeight() {
        commentTableView.layoutIfNeeded()
        let contentHeight = commentTableView.contentSize.height + 20
        
        commentTableView.snp.updateConstraints {
            $0.height.equalTo(contentHeight)
        }
    }
    
    private func setupConstraints() {
        backgroundScrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(backgroundScrollView.contentLayoutGuide)
            $0.width.equalTo(backgroundScrollView.frameLayoutGuide)
        }
        
        writerView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(0)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(68)
        }
        
        writerImageView.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.top).offset(12)
            $0.leading.equalTo(writerView.snp.leading).offset(20)
            $0.width.height.equalTo(44)
        }
        
        writerNameLabel.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.top).offset(16)
            $0.leading.equalTo(writerImageView.snp.trailing).offset(12)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(writerImageView.snp.trailing).offset(12)
        }
        
        postWrittenTimeLabel.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(0)
        }
        
        viewsImageView.snp.makeConstraints {
            $0.centerY.equalTo(writerView.snp.centerY)
            $0.trailing.equalTo(writerView.snp.trailing).offset(-50)
        }
        
        viewsCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerView.snp.centerY)
            $0.leading.equalTo(viewsImageView.snp.trailing).offset(3)
            $0.trailing.equalTo(writerView.snp.trailing).offset(20)
        }
        
        lineSeparator.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        tipView.snp.makeConstraints {
            $0.top.equalTo(lineSeparator.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tipView.snp.top).offset(24)
            $0.leading.trailing.equalTo(tipView).inset(20)
        }
        
        mainTexLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(tipView).inset(20)
        }
        
        tipImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(mainTexLabel.snp.bottom).offset(40)
            $0.leading.equalTo(tipView.snp.leading).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(70)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.top.equalTo(tipImageCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(tipView).inset(20)
            $0.bottom.equalTo(socialView.snp.top)
                .offset(-20)
            $0.height.equalTo(0)
        }
        
        socialView.snp.makeConstraints {
            $0.top.equalTo(tagsCollectionView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tipView.snp.bottom).offset(-20)
            $0.height.equalTo(25)
        }
        
        bottomSeparator.snp.makeConstraints {
            $0.top.equalTo(tipView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(8)
        }
        
        commentInfoView.snp.makeConstraints {
            $0.top.equalTo(bottomSeparator.snp.bottom)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(contentView)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentInfoView.snp.leading).offset(20)
            $0.centerY.equalTo(commentInfoView.snp.centerY)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(commentInfoView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(100)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-50)
        }
        
        commentInputBackgroundView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        commentPlaceholderLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        commentInputTextView.snp.makeConstraints {
            $0.top.equalTo(commentInputBackgroundView.snp.top).offset(16)
            $0.bottom.equalTo(commentInputBackgroundView.snp.bottom).offset(-10)
            $0.leading.equalTo(commentInputBackgroundView.snp.leading).offset(20)
            $0.trailing.equalTo(commentInputBackgroundView.snp.trailing).offset(-100)
            
            let size = commentInputTextView.sizeThatFits(
                CGSize(
                    width: commentInputTextView.frame.width,
                    height: .greatestFiniteMagnitude
                )
            )
            
            $0.height.equalTo(size.height)
        }
        
        submitCommentButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(30)
            $0.bottom.equalTo(commentInputBackgroundView.snp.bottom).offset(-10)
            $0.trailing.equalTo(commentInputBackgroundView.snp.trailing).offset(-20)
        }
    }
    
    private func setupGesture() {
        writerView.addGestureRecognizer(writerTapGesture)
        writerView.isUserInteractionEnabled = true
    }
    
    private func updateLikeButton(for count: Int, isLiked: Bool) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        let likeImage: UIImage = isLiked ?
            .et_getImage(for: .likeImage_fill) :
            .et_getImage(for: .likeImage_empty)
        
        configuration.image = likeImage
        configuration.imagePadding = 6
        
        let attributedTitle = AttributedString(
            "좋아요 \(count)",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        
        return configuration
    }
    
    private func showDeleteAlert(
        contentType: EllipsisButtonType,
        actionType: EllipsisButtonActionType,
        confirmHandler: @escaping () -> Void
    ) {
        let (title, message, style): (String, String?, UIAlertAction.Style) = {
            switch actionType {
            case .delete:
                if contentType == .tip {
                    return (
                        "작성하신 팁을 삭제할까요?",
                        "삭제하면 다시 복구할 수 없습니다.",
                        .destructive
                    )
                } else {
                    return (
                        "댓글을 삭제할까요?",
                        "삭제된 댓글은 다시 복구할 수 없습니다.",
                        .destructive
                    )
                }
            case .report:
                if contentType == .tip {
                    return (
                        "이 팁을 신고할까요?",
                        "커뮤니티 가이드에 따라 신고 사유에 해당하는지 검토 후 처리됩니다.",
                        .default
                    )
                } else {
                    return (
                        "이 댓글을 신고할까요?",
                        "커뮤니티 가이드에 따라 신고 사유에 해당하는지 검토 후 처리됩니다.",
                        .default
                    )
                }
            }
        }()
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "예", style: style) { _ in
            confirmHandler()
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension TipDetailViewController: View {
    func bind(reactor: TipDetailReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: TipDetailReactor) {
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        submitCommentButton.rx.tap
            .withLatestFrom(commentInputTextView.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .bind { [weak self] content in
                self?.coordinator?.checkLoginBeforeAction {
                    // 대댓글 기능 임시 미지원
                    let parentID: Int? = nil
                    self?.reactor?.action.onNext(
                        .commentSubmitTapped(
                            content: content,
                            parentID: parentID
                        )
                    )
                }
            }
            .disposed(by: disposeBag)
        
        ellipsisButton.rx.tap
            .bind { [weak self] in
                guard let isMine = self?.reactor?.currentState.tip?.isMine else { return }
                if isMine {
                    self?.showDeleteAlert(
                        contentType: .tip,
                        actionType: .delete
                    ) {
                        self?.reactor?.action.onNext(.tipEllipsisTapped)
                    }
                } else {
                    self?.showDeleteAlert(
                        contentType: .tip,
                        actionType: .report
                    ) {
                        self?.coordinator?.checkLoginBeforeAction {
                            self?.reactor?.action.onNext(.reportTip)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
            
        likeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.coordinator?.checkLoginBeforeAction {
                    self?.reactor?.action.onNext(.likeButtonTapped)
                }
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.coordinator?.checkLoginBeforeAction {
                    self?.reactor?.action.onNext(.tipSaveButtonTapped)
                }
            }
            .disposed(by: disposeBag)
        
        writerTapGesture.rx.event
            .map { _ in Reactor.Action.userProfileTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipImageCollectionView.rx.itemSelected
            .map { Reactor.Action.imageSelected($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: TipDetailReactor) {
        reactor.state.compactMap { $0.tip }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tip in
                if let writerImageUrlString = tip.writer.profileImage {
                    self?.writerImageView.kf.setImage(
                        with: URL(string: writerImageUrlString),
                        placeholder: UIImage.et_getImage(for: .blankImage)
                    )
                }
                
                let saveImage: UIImage = tip.isSaved
                ? .et_getImage(for: .bookmark_fill)
                : .et_getImage(for: .bookmark)
                
                self?.saveButton.configuration?.image = saveImage
                
                self?.writerNameLabel.text = tip.writer.name
                self?.categoryLabel.text = "\(tip.categoryName) ・ "
                self?.postWrittenTimeLabel.text = tip.createdAt.timeAgo()
                self?.viewsCountLabel.text = tip.views.toAbbreviatedString()
                self?.titleLabel.text = tip.title
                self?.mainTexLabel.text = tip.content
                let likeCount = tip.likes
                self?.likeButton.configuration = self?.updateLikeButton(
                    for: likeCount,
                    isLiked: tip.isLiked
                )
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.tip?.tags }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: tagsCollectionView.rx.items(
                cellIdentifier: TagCollectionViewCell.reuseIdentifier,
                cellType: TagCollectionViewCell.self)
            ) { _, tag, cell in
                cell.updateTag(tag)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.comment?.count }
            .map { "댓글 \($0 ?? 0)" }
            .observe(on: MainScheduler.instance)
            .bind(to: commentCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: 댓글 작성 완료시 높이 조정 동작의 검토 필요
        reactor.state
            .compactMap { $0.comment }
            .observe(on: MainScheduler.instance)
            .bind(to: commentTableView.rx.items(
                cellIdentifier: CommentTableViewCell.reuseIdentifier,
                cellType: CommentTableViewCell.self)
            ) { _, data, cell in
                cell.configureCell(with: data)
                cell.setupAction()
                
                cell.likeButtonTapped
                    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                    .bind { [weak self] in
                        self?.coordinator?.checkLoginBeforeAction {
                            self?.reactor?.action.onNext(
                                .commentLikeButtonTapped(commentID: data.id)
                            )
                        }
                    }
                    .disposed(by: cell.disposeBag)
                                
                if let reactor = self.reactor {
                    cell.profileImageTapped
                        .map { Reactor.Action.commentProfileTapped(userID: data.writer.id) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                }
                
                
                // TODO: 신고 API 연결
                
                cell.ellipsisTapped
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        if data.isMine {
                            self.showDeleteAlert(
                                contentType: .comment,
                                actionType: .delete
                            ) {
                                reactor.action.onNext(.commnetEllipsisTapped(commentID: data.id))
                            }
                        } else {
                            self.showDeleteAlert(
                                contentType: .comment,
                                actionType: .report
                            ) {
                                self.coordinator?.checkLoginBeforeAction {
                                    reactor.action.onNext(.reportComment)
                                } 
                            }
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.comment }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateTableViewHeight()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] message in
                self?.showToast(message: message)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$popSignal)
            .filter { $0 == true }
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                self?.coordinator?.didFinish()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.tip }
            .map { tip in (tip.isLiked, tip.likes) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                let (isLiked, likeCount) = result
                self?.likeButton.configuration = self?.updateLikeButton(
                    for: likeCount,
                    isLiked: isLiked
                )
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$commentSubmittedSignal)
            .compactMap { $0 }
            .filter { $0 }
            .bind { [weak self] _ in
                self?.commentInputTextView.text = nil
                self?.commentPlaceholderLable.isHidden = false
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$userTappedSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let userID = reactor.currentState.tip?.writer.id else {
                    return
                }
                self?.coordinator?.pushToUserProrfileView(userID: userID)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.tip?.images }
            .observe(on: MainScheduler.instance)
            .bind(to: tipImageCollectionView.rx.items(
                cellIdentifier: TipPhotoCollectionViewCell.reuseIdentifier,
                cellType: TipPhotoCollectionViewCell.self)
            ) { _, item, cell in
                cell.configureCell(with: item.url)
            }
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$selectedImageIndex)
            .compactMap { $0 }
            .bind { [weak self] selectedIndex in
                guard let self,
                      let images = self.reactor?.currentState.tip?.images else { return }
                
                let urls = images.map(\.url)
                
                coordinator?.presentDetailPhoto(with: urls, startIndex: selectedIndex)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$commentProfileTappedSignal)
            .compactMap { $0 }
            .bind { [weak self] in
                self?.coordinator?.pushToUserProrfileView(userID: $0)
            }
            .disposed(by: disposeBag)
    }
}
extension TipDetailViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let isLoggedIn = TokenKeyChainManager.shared.isLoggedIn
            if isLoggedIn {
                return true
            } else {
                coordinator?.checkLoginBeforeAction(onLoggedIn: { [weak self] in
                    self?.commentInputTextView.becomeFirstResponder()
                })
                return false
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            commentPlaceholderLable.isHidden = !textView.text.isEmpty

            let maxHeight: CGFloat = 100
            let size = textView.sizeThatFits(
                CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
            )
            let newHeight = min(size.height, maxHeight)

            commentInputTextView.isScrollEnabled = size.height > maxHeight
            commentInputTextView.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
        }
}
