//
//  Token.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/28.
//

import Foundation
import Alamofire
import UIKit

struct TokenResponseData: Codable {
    let code: Int
    let message: String
    let data: TokenDataInfo
}

struct TokenDataInfo: Codable {
    let access_token: String
    let refresh_token: String
}

struct Token {
    func reissuingToken(completionHandler: @escaping (Result <TokenResponseData, Error> ) -> Void) {
        let url = LoginUrlCategory().REFRESH_TOKEN_URL
        
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else { return }
        guard let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Refresh": "Bearer \(refreshToken)"
        ]
        
        AF.request(url, method: .get, headers: headers)
                .responseData(completionHandler: { response in

                switch response.result {
                case let .success(data):
//                    guard let statusCode = response.response?.statusCode else { return }
//                    if statusCode == 200 {
//
//                    }
                    let decoder = JSONDecoder()
                    do {
                      let result = try decoder.decode(TokenResponseData.self, from: data)
                        
                        let accessToken = result.data.access_token
                        let refreshToken = result.data.refresh_token
                        
                        UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                        UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
                        
                       completionHandler(.success(result))
                    } catch {
                      completionHandler(.failure(error))
                    }
                case let .failure(error):
                  completionHandler(.failure(error))
                }
            }
          )
    }
    
}
