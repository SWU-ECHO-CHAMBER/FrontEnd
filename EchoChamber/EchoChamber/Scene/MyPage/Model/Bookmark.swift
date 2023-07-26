//
//  Bookmark.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/26.
//

import Foundation

struct Bookmark : Decodable {
    let code : Int
    let message : String
    let data : [BookmarkDataClass]
    
    struct BookmarkDataClass : Decodable {
        let newsID : Int
        let title, source, publishedAt, author : String
        let imageURL : String
        
        enum CodingKeys : String, CodingKey {
            case newsID = "news_id"
            case title, source, author
            case publishedAt = "published_at"
            case imageURL = "image_url"
        }
    }
}
