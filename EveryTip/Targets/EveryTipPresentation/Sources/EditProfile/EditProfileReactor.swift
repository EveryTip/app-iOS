//
//  EditProfileReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/26/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

// TODO: 회원 탈퇴 및 비밀번호 변경 API 연동

final class EditProfileReactor: Reactor {
    
    enum EditProfileItem {
        case changePassword
        case manageBlockedUser
        case deleteAccount
    }
    
    enum Action {
        case itemSelected(Int)
        case EditProfileImageTapped
        case deleteAccount
    }
    
    enum Mutation {
        case setChangePasswordSignal(Bool)
        case setDeleteAccountSignal(Bool)
        case setToast(String)
        case setManageBlockedUserSignal(Bool)
        case setDismissSignal(Bool)
    }
    
    struct State {
        var nickName: String?
        var options: [EditProfileItem] = [
            .changePassword,
            .manageBlockedUser,
            .deleteAccount
        ]
        
        @Pulse var changePasswordSignal: Bool = false
        @Pulse var deleteAccountSignal: Bool = false
        @Pulse var manageBlockedUserSignal: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var dismissSignal: Bool = false
    }
    
    private let authUseCase: AuthUseCase
    
    var initialState: State
    
    init(authUseCase: AuthUseCase,
         nickName:String) {
        self.authUseCase = authUseCase
        self.initialState = State(nickName: nickName)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
       
        switch action {
        case .itemSelected(let index):
            switch index {
                
            case 0:
                return .just(.setChangePasswordSignal(true))
                
            case 1:
                return .just(.setManageBlockedUserSignal(true))
                
            case 2:
                return .just(.setDeleteAccountSignal(true))
                
            default:
                return .empty()
            }
        case .EditProfileImageTapped:
            return .just(.setToast("프로필 사진 변경은 추후 업데이트 예정이에요!"))
            
        case .deleteAccount:
            return authUseCase.deleteAccount()
                .andThen(
                    Observable.concat([
                        .just(.setDismissSignal(true)),
                        .just(.setToast("계정이 삭제되었어요."))
                    ])
                )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChangePasswordSignal(let signal):
            newState.changePasswordSignal = signal
        case .setDeleteAccountSignal(let signal):
            newState.deleteAccountSignal = signal
        case .setToast(let message):
            newState.toastMessage = message
        case .setDismissSignal(let signal):
            newState.dismissSignal = signal
        case .setManageBlockedUserSignal(let signal):
            newState.manageBlockedUserSignal = signal
        }
        return newState
    }
}
