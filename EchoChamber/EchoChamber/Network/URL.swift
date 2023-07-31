//
//  URL.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

let BASE_URL = "http://localhost:8080"

class LoginUrlCategory {
    
    let EMAIL_LOGIN_URL = "\(BASE_URL)/auth/email"
    let CEHCK_EMAIL_URL = "\(BASE_URL)/auth/email/check"
    let REGISTER_LOGIN_URL = "\(BASE_URL)/auth/email/join"
    let LEAVE_URL = "\(BASE_URL)/auth/leave"
    let LOGOUT_URL = "\(BASE_URL)/auth/logout"
    let REFRESH_TOKEN_URL = "\(BASE_URL)/auth/refresh"
    let SOCIAL_LOGIN_URL = "\(BASE_URL)/auth/social"
    
}

final class NewsUrlCategory {
    
    let ENTIRE_NEWS_URL = "\(BASE_URL)/news"

    func detailNewsUrl(id: Int) -> String {
        return "\(BASE_URL)/news/detail/\(id)"
    }
    
    func editBookmarkURL(newsId: Int) -> String {
        return "\(BASE_URL)/news/mark/\(newsId)"
    }
    
    let POPULAR_NEWS_TOP_URL = "\(BASE_URL)/news/top"
    
}

final class MyPageUrlCategory {
    
    let BOOKMARK_LIST_URL = "\(BASE_URL)/mypage/mark"
    let CHANGE_NICKNAME_URL = "\(BASE_URL)/mypage/nickname"
    let CHANGE_PASSWORD_URL = "\(BASE_URL)/mypage/password"
    let CHANGE_PROFILE_URL = "\(BASE_URL)/mypage/profile-image"
    
}
