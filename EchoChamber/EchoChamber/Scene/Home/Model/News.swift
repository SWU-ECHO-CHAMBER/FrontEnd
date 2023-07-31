//
//  News.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

struct News : Decodable {
    let code: Int
    let message: String
    let data: [NewsData]
    
    struct NewsData : Decodable {
        let newsID: Int
        let title: String
        let source: String
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
}
