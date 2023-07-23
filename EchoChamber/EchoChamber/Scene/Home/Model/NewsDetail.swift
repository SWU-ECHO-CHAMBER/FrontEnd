//
//  NewsDetail.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import Foundation

struct NewsDetail : Decodable {
    
    let newsData : NewsData
    
    struct NewsData : Decodable {
        let data : Data
    }
    
    struct Data : Decodable {
        let newsID : Int
        let title : String
        let content : String
        let source : String
        let publishedAt : String
        let author : String
        let imageURL : String
        let bookmark : Bool
        
        enum CodingKeys : String, CodingKey {
            case title, content, source, author
            case newsID = "news_id"
            case publishedAt  =  "published_at"
            case imageURL = "image_url"
            case bookmark = "marked"
        }
    }
}
