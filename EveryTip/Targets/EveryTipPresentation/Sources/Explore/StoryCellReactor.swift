//
//  ExploreReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class StoryCellReactor: Reactor {
    
    enum Action {
        case cellSelected
    }
    
    enum Mutation {
        case setSelected(Bool)
    }
    
    struct State {
        var isSelected: Bool = false
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cellSelected:
            return Observable.just(.setSelected(!currentState.isSelected))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .setSelected(let isSelected):
            newState.isSelected = isSelected
        }
        
        return newState
    }
}
