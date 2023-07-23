//
//  StatusCode.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

// MARK: - StatusCode 코드와 메시지

enum LoginStatusCode : Int {
    case ok = 200
    case UserNotFound = 401
    case NotMatchPassword = 403
    case ServerError = 500
    
    var description: String {
        switch self {
        case .ok :
            return "로그인 성공!"
        case .UserNotFound:
            return "이메일이 존재하지 않습니다."
        case .NotMatchPassword:
            return "비밀번호가 일치하지 않습니다."
        case .ServerError:
            return "서버 코드 에러 ☠️. 관리자에게 문의 부탁드립니다."
        }
    }
}

enum EntireNewsStatusCode : Int {
    case DataNotFound = 404
    case ServerError = 500
    
    var description: String {
        switch self {
        case .DataNotFound:
            return "데이터 요청중..."
        case .ServerError:
            return "서버 코드 에러 ☠️. 관리자에게 문의 부탁드립니다."
        }
    }
}
