//
//  NewsDetail.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

struct NewsDetail: Decodable {
    let code: Int
    let message: String
    let data: NewsDetailDataClass
}

// MARK: - DataClass
struct NewsDetailDataClass: Decodable {
    let newsID: Int
    let title, content, source, publishedAt: String
    let author: String
    let imageURL: String
    let marked: Bool
    let url : String

    enum CodingKeys: String, CodingKey {
        case newsID = "news_id"
        case title, content, source
        case publishedAt = "published_at"
        case author
        case imageURL = "image_url"
        case marked
        case url
    }
}
