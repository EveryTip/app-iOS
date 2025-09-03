//
//  HomeReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

class HomeReactor: Reactor {
    typealias Category = EveryTipDomain.Category
    typealias SectionType = HomeTableViewSection.SectionType
    
    enum Action {
        case viewDidLoad
        case itemSelected(Tip)
        case refresh
        case searchButtonTapped
        case headerSectionButtonTapped(sectionType: SectionType)
        case weeklyTipButtonTapped
    }
    
    enum Mutation {
        case setTips([Tip])
        case setSelectedTip(Tip)
        case setToast(String)
        case setPushSignal(Bool)
        case setSearchSiganl(Bool)
        case setMyCategories([Category])
        case setSelectedSection(SectionType)
        case setWeeklyTipTappedSignal(Bool)
    }
    
    struct State {
        var tips: [Tip] = []
        var selectedTip: Tip?
        
        var popularTips: [Tip] = []
        var categorizedTips: [Tip] = []
        var myCategories: [Category] = []
        
        @Pulse var pushSignal: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var searchSignal: Bool = false
        @Pulse var selectedSection: SectionType?
        @Pulse var weeklyTipTappedSignal: Bool = false
    }
    
    let initialState: State
    private let tipUseCase: TipUseCase
    private let userUseCase: UserUseCase
    
    init(
        tipUseCase: TipUseCase,
        userUseCase: UserUseCase
    ) {
        self.tipUseCase = tipUseCase
        self.userUseCase = userUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            
            let categories = userUseCase.fetchMyCategories()
                .asObservable()
                .map { Mutation.setMyCategories($0) }
                        
            let tips = tipUseCase.fetchTotalTips()
                .asObservable()
                .map { Mutation.setTips($0) }
                .catch { _ in
                    return Observable.just(.setToast("팁 목록을 불러오는데 실패했어요. 잠시 후 다시 시도해주세요"))
                }
            
            return Observable.merge(categories,tips)
            
        case .itemSelected(let tip):
            return Observable.concat(
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            )
            
        case .refresh:
            return tipUseCase.fetchTotalTips()
                .asObservable()
                .map { return Mutation.setTips($0) }
                .catch { _ in
                    return Observable.just(.setToast("팁 목록을 불러오는데 실패했어요. 잠시 후 다시 시도해주세요"))
                }
        case .searchButtonTapped:
            return .just(.setSearchSiganl(true))
        case .headerSectionButtonTapped(let section):
            return .just(.setSelectedSection(section))
        case .weeklyTipButtonTapped:
            return .just(.setWeeklyTipTappedSignal(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTips(let tips):
            // 차단 로직 임시 적용, 추후 visibleTips 삭제
            let visibleTips = tips.filteredByBlockedUsers()
            newState.tips = visibleTips
            newState.popularTips = visibleTips.topPopular()
            
            let categoryIDs = newState.myCategories.map { $0.id }
            let filtered = visibleTips.filter { categoryIDs.contains($0.categoryId) }
            newState.categorizedTips = Array(filtered.prefix(3))
            
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setToast(let message):
            newState.toastMessage = message
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        case .setSearchSiganl(let signal):
            newState.searchSignal = signal
        case .setMyCategories(let categories):
            newState.myCategories = categories
            
            
            let categoryIDs = categories.map { $0.id }
            let filtered = newState.tips.filter { categoryIDs.contains($0.categoryId) }
            newState.categorizedTips = Array(filtered.prefix(3))
        case .setSelectedSection(let section):
            newState.selectedSection = section
        case .setWeeklyTipTappedSignal(let signal):
            newState.weeklyTipTappedSignal = signal
        }
        
        return newState
    }
}

//임시 차단 로직

private extension Array where Element == Tip {
    func filteredByBlockedUsers() -> [Tip] {
        let blocked: Set<Int> = BlockManager.blockedUserIds
        return self.filter { tip in
            let authorId = tip.writer.id
            return !blocked.contains(authorId)
        }
    }
}
