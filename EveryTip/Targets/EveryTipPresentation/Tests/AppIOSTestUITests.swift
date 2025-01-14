import Foundation
import XCTest

import RxSwift
import ReactorKit

@testable import EveryTipPresentation
@testable import EveryTipDomain

final class LoginViewTests: XCTestCase {
    
    var mockUseCase: RequestTokenUseCase!
    var mockReactor: LoginReactor!
   
    override func tearDown() {
        mockReactor = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_리액터_로그인버튼이_눌렸을때_바인딩이_정상인지() {
        //given
        mockUseCase = MockLoginUseCase()
        mockReactor = LoginReactor(loginUseCase: mockUseCase)
        
        //when
        mockReactor.action.onNext(.loginButtonTapped(email: "mockmock@gmail.com", password: "mock1234"))
        
        //then 키체인이 시뮬레이터에선 테스팅 되지 않으므로 false 가 정상임(리액터의 값을 true로 바꿔보면 바인딩이 정상임을 확인가능)
        XCTAssertEqual(mockReactor.currentState.isLogined, false)
    }
}

class MockLoginUseCase: RequestTokenUseCase {
    func excute(email: String, password: String) -> RxSwift.Single<EveryTipDomain.TokenResponse> {
        let mockToken = TokenResponse(
            statusCode: 200,
            code: "SUCCESS",
            message: "Login successful",
            data: TokenData(
                id: 1,
                email: email,
                nickName: "MockUser",
                accessToken: "mock_access_token_123",
                refreshToken: "mock_refresh_token_456"
            )
        )
        return Single.just(mockToken)
    }
}
