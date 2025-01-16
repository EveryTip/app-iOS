//
//  ExploreReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import ReactorKit
import RxSwift

final class ExploreReactor: Reactor {
    enum Action {
        case sortButtonTapped(SortOptions)
        case viewDidLoad
        case storyCellTapped(selectedUserName: String)
    }
    
    enum Mutation {
        case setStory([DummyStory])
        case setSortImage(UIImage)
        case setSelectedUserName(String)
    }
    
    struct State {
        var stories: [DummyStory] = []
        var sortButtonImage: UIImage = UIImage.et_getImage(for: .sortImage_latest)
        var selectedUserName: String? = nil
    }
    
    let initialState: State
    
    // TODO: real useCase로 변경
    let useCase = DefaultDummyStory()
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .sortButtonTapped(let option):
            let image: UIImage
            
            switch option {
                
            case .latest:
                image = UIImage.et_getImage(for: .sortImage_latest)
            case .views:
                image = UIImage.et_getImage(for: .sortImage_views)
            case .likes:
                image = UIImage.et_getImage(for: .sortImage_likes)
            }
            return .just(.setSortImage(image))
            
        case .viewDidLoad:
            return useCase
                .getDummy()
                .asObservable()
                .map(Mutation.setStory)
            
        case .storyCellTapped(selectedUserName: let name):
            return .just(Mutation.setSelectedUserName(name))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSortImage(let sortImage):
            newState.sortButtonImage = sortImage
        case .setStory(let stories):
            newState.stories = stories
        case .setSelectedUserName(let name):
            newState.selectedUserName = name
        }
        return newState
    }
}

// TODO: 재사용 되면 파일 분리
enum SortOptions {
    case latest
    case views
    case likes
}
