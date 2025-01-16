//
//  DummyStory.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/15/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import RxSwift

protocol DummyStoryUseCase {
    func getDummy() -> Single<[DummyStory]>
}

struct DummyStory {
    var userName: String
    var userProfileIamge: UIImage
}

final class DefaultDummyStory: DummyStoryUseCase {
    
    let dummy = [
        DummyStory(userName: "강백호", userProfileIamge: .add),
        DummyStory(userName: "서태웅", userProfileIamge: .remove),
        DummyStory(userName: "채치수", userProfileIamge: .actions),
        DummyStory(userName: "정대만", userProfileIamge: .strokedCheckmark),
        DummyStory(userName: "송태섭", userProfileIamge: .remove),
        DummyStory(userName: "권준호", userProfileIamge: .add),
        DummyStory(userName: "이달재", userProfileIamge: .remove),
        DummyStory(userName: "신오일", userProfileIamge: .actions),
        DummyStory(userName: "채소연", userProfileIamge: .strokedCheckmark),
        DummyStory(userName: "이한나", userProfileIamge: .remove),
        DummyStory(userName: "윤대협", userProfileIamge: .add),
        DummyStory(userName: "변덕규", userProfileIamge: .remove),
        DummyStory(userName: "황태산", userProfileIamge: .actions),
        DummyStory(userName: "허태환", userProfileIamge: .strokedCheckmark),
        DummyStory(userName: "안영수", userProfileIamge: .remove),
    ]
    
    func getDummy() -> Single<[DummyStory]> {
        return Single.just(dummy)
    }
}
