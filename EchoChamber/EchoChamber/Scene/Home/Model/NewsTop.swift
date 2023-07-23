//
//  NewsTop.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

struct NewsTop : Decodable {
    let code: Int
    let message: String
    let data: NewsTopData
    
    struct NewsTopData : Decodable {
        let newsID : Int
        let title: String
        let source : Source
        let publishedAt: String
        let author: String?
        let imageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case newsID = "news_id"
            case title, source
            case publishedAt = "published_at"
            case author
            case imageURL = "image_url"
        }
    }

    enum Source : String, Decodable {
        case cnn = "CNN"
        case time = "Time"
    }
}
