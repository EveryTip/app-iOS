//
//  NetworkError.swift
//  EveryTipData
//
//  Created by 김경록 on 9/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case httpError(code: Int)
    case invalidURLError
    case sessionError(Error)
    case responseSerializationError(Error)
    case responseValidationError(Error)
    case serverTrustError(Error)
    case requestAdaptationError(Error)
    case requestRetryError(Error)
    case baseURLError
    case invalidEmail
    case emptyResponseData
    case wrongPassword
    
    var errorDescription: String? {
        switch self {
        case .httpError(let code):
            return "HTTP 오류: 코드 \(code))"
        case .invalidURLError:
            return "잘못된 URL입니다."
        case .sessionError(let error):
            return "세션 오류: \(error.localizedDescription)"
        case .responseSerializationError(let error):
            return "응답 직렬화 오류: \(error.localizedDescription)"
        case .responseValidationError(let error):
            return "응답 검증 오류: \(error.localizedDescription)"
        case .serverTrustError(let error):
            return "서버 신뢰성 평가 오류: \(error.localizedDescription)"
        case .requestAdaptationError(let error):
            return "요청 적응 오류: \(error.localizedDescription)"
        case .requestRetryError(let error):
            return "요청 재시도 오류: \(error.localizedDescription)"
        case .baseURLError:
            return "plist에서 BaseURL을 가져오는데에 실패했어요"
        case .invalidEmail:
            return "사용 불가능한 이메일입니다."
        case .emptyResponseData:
            return "데이터가 없습니다"
        case .wrongPassword:
            return "비밀번호가 올바르지 않습니다."
        }
    }
}
