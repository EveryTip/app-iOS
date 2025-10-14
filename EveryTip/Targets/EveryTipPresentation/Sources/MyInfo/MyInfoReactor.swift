//
//  MyInfoReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import EveryTipCore
import EveryTipDomain
import Foundation
import ReactorKit
import RxSwift

final class MyInfoReactor: Reactor {
    private let tokenManager = TokenKeyChainManager.shared
    
    // MARK: - Row Model
    enum InfoTableViewItem: Equatable {
        case setSubscribe
        case setCategories
        case agreement
        case version(String)
        case login
        case logout

        var title: String {
            switch self {
            case .setSubscribe:
                return "구독 설정"
            case .setCategories:
                return "관심사 설정"
            case .agreement:
                return "이용약관"
            case .version(_):
                return "버전 정보"
            case .login:
                return "로그인"
            case .logout:
                return "로그아웃"
            }
        }
    }

    // MARK: - Reactor
    enum Action {
        case refresh
        case applyGuestProfile
        case agreementCellTapped
        case logoutCellTapped
        case logoutConfirmTapped
        case editProfileButtonTapped
        case setCategoryButtonTapped
        case setSubscribeButtonTapped
        case loginCellTapped
    }

    enum Mutation {
        case setMyProfileData(MyProfile)
        case setToast(String)
        case setItems([InfoTableViewItem])

        // Navigation Signal
        case setLogoutCellSignal
        case setAgreementCellSignal
        case setEditProfileSignal
        case setCategorySignal
        case setSubscribeSignal
        case setLoginCellSignal

        case setLogoutConfirmSignal(Bool)
    }

    struct State {
        var myProfile: MyProfile
        var items: [InfoTableViewItem] = []

        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: NavigationSignal?

        enum NavigationSignal {
            case agreement
            case logout
            case userContents
            case setCategories
            case editProfile
            case setSubscribe
            case login
        }
        @Pulse var logoutConfirmSignal: Bool = false
    }

    // initialState는 self 참조가 필요하므로 lazy 사용
    lazy var initialState: State = State(
        myProfile: guestProfile,
        items: makeItems()
    )

    // API가 토큰 없을 시 에러만 반환하므로 더미데이터로 대체
    private let guestProfile = MyProfile(
        id: 0,
        status: 0,
        nickName: "게스트",
        profileImageURL: nil,
        email: "everytip",
        registeredDate: "00",
        tipCount: 0,
        savedTipCount: 0,
        subscriberCount: 0
    )

    private let userUseCase: UserUseCase

    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }

    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return userUseCase.fetchMyProfile()
                .asObservable()
                .flatMap { [weak self] profile -> Observable<Mutation> in
                    guard let self else { return .just(.setToast("잠시 후 다시 시도해주세요")) }
                    return .from([
                        .setMyProfileData(profile),
                        .setItems(self.makeItems())
                    ])
                }
                .catch { [weak self] _ in
                    guard let self else { return .just(.setToast("잠시 후 다시 시도해주세요")) }
                    return .from([
                        .setMyProfileData(self.guestProfile),
                        .setItems(self.makeItems())
                    ])
                }

        case .logoutCellTapped:
            return .just(.setLogoutCellSignal)

        case .logoutConfirmTapped:
            if tokenManager.isLoggedIn {
                tokenManager.deleteToken(type: .access)
                tokenManager.deleteToken(type: .refresh)
                return .concat(
                    .just(.setMyProfileData(guestProfile)),
                    .just(.setItems(self.makeItems())),
                    .just(.setToast("로그아웃 되었어요")),
                    .just(.setLogoutConfirmSignal(true))
                )
            } else {
                return .just(.setToast("로그인이 되어있지않아요."))
            }

        case .agreementCellTapped:
            return .just(.setAgreementCellSignal)

        case .editProfileButtonTapped:
            return .just(.setEditProfileSignal)

        case .setCategoryButtonTapped:
            return .just(.setCategorySignal)

        case .setSubscribeButtonTapped:
            return .just(.setSubscribeSignal)

        case .loginCellTapped:
            return .just(.setLoginCellSignal)

        case .applyGuestProfile:
            return .from([
                .setMyProfileData(self.guestProfile),
                .setItems(self.makeItems())
            ])
        }
    }

    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setMyProfileData(let myProfile):
            newState.myProfile = myProfile

        case .setToast(let message):
            newState.toastMessage = message

        case .setLogoutConfirmSignal(let signal):
            newState.logoutConfirmSignal = signal

        case .setAgreementCellSignal:
            newState.navigationSignal = .agreement

        case .setLogoutCellSignal:
            newState.navigationSignal = .logout

        case .setEditProfileSignal:
            newState.navigationSignal = .editProfile

        case .setCategorySignal:
            newState.navigationSignal = .setCategories

        case .setSubscribeSignal:
            newState.navigationSignal = .setSubscribe

        case .setLoginCellSignal:
            newState.navigationSignal = .login

        case .setItems(let items):
            newState.items = items
        }

        return newState
    }

    // MARK: - Helpers
    private let appVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "-"
        }
        return version
    }()

    private func makeItems() -> [InfoTableViewItem] {
        var base: [InfoTableViewItem] = [
            .setSubscribe,
            .setCategories,
            .agreement,
            .version(appVersion)
        ]
        if tokenManager.isLoggedIn {
            base.append(.logout)
        } else {
            base.append(.login)
        }
        return base
    }
}
