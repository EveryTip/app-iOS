//
//  UserProfileReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class UserProfileReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case subScribeButtonTapped
        case sortButtonTapped(SortOptions)
        case itemSelected(Tip)
        case profileEllipsisButtonTapped
        case reportUser
        case blockUser
    }
    
    enum Mutation {
        case setUserProfile(UserProfile)
        case setTips([Tip])
        case setSortedTips([Tip])
        case setSortOption(SortOptions)
        case setSelectedTip(Tip)
        case setPushSignal(Bool)
        case setToast(String)
        case setEllipsisSignal(Bool)
    }
    
    struct State {
        var userProfile: UserProfile?
        var tips: [Tip] = []
        var sortOption: SortOptions = .latest
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var ellipsisSignal: Bool = false
    }
    
    var initialState: State = State()
    
    private let userID: Int
    
    private let userUseCase: UserUseCase
    private let tipUseCase: TipUseCase
    
    init(
        userID: Int,
        userUseCase: UserUseCase,
        tipUseCase: TipUseCase
    ) {
        self.userID = userID
        self.userUseCase = userUseCase
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fetchTips = tipUseCase
                .fetchTips(forUserID: userID)
                .asObservable()
                .map { Mutation.setTips($0) }
            
            let fetchProfile = userUseCase
                .fetchUserProfile(for: userID)
                .asObservable()
                .map { Mutation.setUserProfile($0) }
            
            return Observable.merge(
                fetchTips,
                fetchProfile
            )
            
        case .subScribeButtonTapped:
                    
            guard let isFollowing = currentState.userProfile?.isFollowing else {
                return .just(.setToast("유저 정보를 얻어오는데에 실패했어요."))
            }
            
            let toastMessage = isFollowing ? "구독이 해제되었어요." : "구독을 추가햇어요."
            
            return userUseCase.toggleSubscription(to: userID)
                .andThen(userUseCase.fetchUserProfile(for: userID).asObservable())
                .flatMap { updatedProfile in
                    return Observable.from([
                        .setUserProfile(updatedProfile),
                        .setToast(toastMessage)
                    ])
                }
            
        case .sortButtonTapped(let option):
            let sortedTips = currentState.tips.sorted(by: option.toTipOrder())
            return Observable.from([
                .setSortedTips(sortedTips),
                .setSortOption(option)
            ])
            
        case .itemSelected(let tip):
            return Observable.concat([
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            ])
        case .profileEllipsisButtonTapped:
            return .just(.setEllipsisSignal(true))
        case .reportUser:
            return userUseCase.reportUser().andThen(
                .just(.setToast("유저 신고가 접수되었습니다."))
            )
        case .blockUser:
            return Observable.deferred { [weak self] in
                guard let self = self else { return .just(.setToast("알 수 없는 오류가 발생했어요.")) }
                let id = self.userID
                
                if BlockManager.isBlocked(userId: id) {
                    return .just(.setToast("이미 차단한 사용자예요."))
                } else {
                    BlockManager.block(userId: id)
                    return .just(.setToast("사용자를 차단했어요. 더 이상 이 사용자의 콘텐츠가 표시되지 않아요."))
                }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUserProfile(let profile):
            newState.userProfile = profile
            
        case .setTips(let tips):
            newState.tips = tips
            
        case .setSortedTips(let sortedTips):
            newState.tips = sortedTips
            
        case .setSortOption(let option):
            newState.sortOption = option
            
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
            
        case .setPushSignal(let flag):
            newState.pushSignal = flag
        case .setToast(let message):
            newState.toastMessage = message
        case .setEllipsisSignal(let signal):
            newState.ellipsisSignal = signal
        }
        
        return newState
    }
}
