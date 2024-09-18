//
//  Article.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let articles: [Article]
}

// Model to get the response and parse it.
struct Article: Identifiable, Decodable {
    var id: String {
        return UUID().uuidString
    }
    let title: String
    let subtitle: String?
    let imageUrl: URL?
    let content: String?
    let url: URL
    let source: Source
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle = "description" 
        case imageUrl = "urlToImage"
        case content
        case url
        case source
        case publishedAt
    }
}

struct Source: Codable {
    let name: String
}
