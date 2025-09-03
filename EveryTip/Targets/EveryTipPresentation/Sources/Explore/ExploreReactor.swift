//
//  ExploreReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import UIKit
import EveryTipDomain
import ReactorKit
import RxSwift

final class ExploreReactor: Reactor {
    enum Action {
        case sortButtonTapped(SortOptions)
        case refresh
        case storyCellTapped(selectedStory: Story)
        case itemSelected(Tip)
    }

    enum Mutation {
        case setStory([Story])
        case setSortButton(SortOptions)
        case setSelectedStory(Story)
        case setAllTips([Tip])
        case setVisibleTips([Tip])
        case setSelectedTip(Tip)
        case setPushSignal(Bool)
    }

    struct State {
        var stories: [Story]
        var sortOption: SortOptions = .latest
        var selectedStory: Story
        var allTips: [Tip] = []        // 원본 전체 tips 저장
        var visibleTips: [Tip] = []    // 현재 UI에 보여줄 tips
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
    }

    private let tipUseCase: TipUseCase
    private let userUseCase: UserUseCase

    let initialState: State

    // 첫 번째 셀은 항상 "전체 팁"
    private var initialStory: [Story] = [
        Story(type: .everyTip, user: nil)
    ]

    init(tipUseCase: TipUseCase, userUseCase: UserUseCase) {
        self.tipUseCase = tipUseCase
        self.userUseCase = userUseCase
        self.initialState = State(
            stories: initialStory,
            selectedStory: initialStory[0]
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        case .sortButtonTapped(let option):
            let sortedTips = currentState.visibleTips.sorted(by: option.toTipOrder())
            return Observable.merge(
                .just(.setVisibleTips(sortedTips)),
                .just(.setSortButton(option))
            )

        case .refresh:
            let followersObservable = userUseCase.fetchMyFollowing()
                .asObservable()
                .catchAndReturn([])
                .map { followers -> Mutation in
                    // 🔒 차단 유저 제외
                    let visibleFollowers = followers.filteredByBlockedUsers()
                    let stories: [Story] = [Story(type: .everyTip, user: nil)]
                        + visibleFollowers.map { Story(type: .user, user: $0) }
                    return .setStory(stories)
                }

            let tipsObservable = tipUseCase.fetchTotalTips()
                .asObservable()
                .catchAndReturn([])
                .flatMap { tips -> Observable<Mutation> in
                    // 🔒 차단 유저 글 제외
                    let visibleTips = tips.filteredByBlockedUsers()
                    return Observable.concat([
                        .just(.setAllTips(visibleTips)),
                        .just(.setVisibleTips(visibleTips)),
                        .just(.setSelectedStory(Story(type: .everyTip, user: nil)))
                    ])
                }

            return Observable.merge(followersObservable, tipsObservable)

        case .storyCellTapped(let story):
            let userID = story.user?.id ?? 0
            let filteredTips: [Tip]
            if userID == 0 {
                filteredTips = currentState.allTips
            } else {
                filteredTips = currentState.allTips.filtered(using: .userID(userID))
            }

            return Observable.concat([
                .just(.setSelectedStory(story)),
                .just(.setVisibleTips(filteredTips))
            ])

        case .itemSelected(let tip):
            return Observable.concat([
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setSortButton(let option):
            newState.sortOption = option

        case .setStory(let stories):
            newState.stories = stories

        case .setSelectedStory(let story):
            newState.selectedStory = story

        case .setAllTips(let tips):
            newState.allTips = tips

        case .setVisibleTips(let tips):
            newState.visibleTips = tips

        case .setSelectedTip(let tip):
            newState.selectedTip = tip

        case .setPushSignal(let flag):
            newState.pushSignal = flag
        }

        return newState
    }
}

// MARK: - Story Model

struct Story {
    var type: StoryType
    var user: UserPreview?

    enum StoryType {
        case user
        case everyTip
    }
}

//임시 차단 로직

private extension Array where Element == Tip {
    func filteredByBlockedUsers() -> [Tip] {
        let blocked: Set<Int> = BlockManager.blockedUserIds
        return self.filter { tip in
            !blocked.contains(tip.writer.id)
        }
    }
}

private extension Array where Element == UserPreview {
    func filteredByBlockedUsers() -> [UserPreview] {
        let blocked: Set<Int> = BlockManager.blockedUserIds
        return self.filter { user in
            !blocked.contains(user.id)
        }
    }
}
