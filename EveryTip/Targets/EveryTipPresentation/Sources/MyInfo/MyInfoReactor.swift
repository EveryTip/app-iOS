//
//  MyInfoReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

class MyInfoReactor: Reactor {
    enum Action {
        // TODO: 프로필 편집, 각 아이템 터치 처리
        case viewDidLoad
    }
    
    enum Mutation {
        //viewDidLoad 시
        case setMyProfileData(MyProfile)
        case setError(Error)
    }
    
    struct State {
        var myProfile: MyProfile?
        var userName: String?
        var subscribersCount: String?
        var postedTipCount: String?
        var savedTipCount: String?
        
        var fetchError: Error?
    }
    
    let initialState: State
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        self.initialState = State(
            userName: "게스트",
            subscribersCount: "0",
            postedTipCount: "0",
            savedTipCount: "0"
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userUseCase.fetchMyProfile()
                .asObservable()
                .map(Mutation.setMyProfileData)
                .catch { error in
                    Observable.just(Mutation.setError(error))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setMyProfileData(let myProfile):
            newState.myProfile = myProfile
            newState.userName = myProfile.nickName
            newState.subscribersCount = myProfile.subscriberCount.toAbbreviatedString()
            newState.postedTipCount = myProfile.tipCount.toAbbreviatedString()
            newState.savedTipCount = myProfile.savedTipCount.toAbbreviatedString()
        case .setError(let error):
            newState.fetchError = error
        }
        
        return newState
    }
    
    func getInfoTableViewItems() -> [String] {
        Constants.MyInfo.tableViewItems
    }
}
