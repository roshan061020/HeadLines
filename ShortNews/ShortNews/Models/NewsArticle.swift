//
//  NewsArticle.swift
//  Headlines
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation
import CoreData

// Model to work with views and storage
struct NewsArticle: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String?
    let imageUrl: URL?
    let content: String?
    let url: URL
    let source: Source
    let publishedAt: Date?
    var isBookmarked: Bool
    let category: String
}


extension NewsArticle {
    
    init?(from articleEntity: ArticleEntity) {
        guard let id = articleEntity.id,
              let title = articleEntity.title,
              let urlString = articleEntity.url,
              let url = URL(string: urlString),
              let sourceName = articleEntity.source?.name,
              let publishedAt = articleEntity.publishedAt,
              let categoryName = articleEntity.category?.name else {
            print("Skipping article entity due to missing properties")
            return nil
        }
        
        self.id = id
        self.title = title
        self.subtitle = articleEntity.subtitle
        self.imageUrl = articleEntity.imageUrl != nil ? URL(string: articleEntity.imageUrl!) : nil
        self.content = articleEntity.content
        self.url = url
        self.source = Source(name: sourceName)
        self.publishedAt = publishedAt
        self.isBookmarked = articleEntity.isBookmarked
        self.category = categoryName
    }
    
    init(from article: Article, for category: String) {
        self.id = article.id
        self.title = article.title
        self.subtitle = article.subtitle
        self.imageUrl = article.imageUrl
        self.content = article.content
        self.url = article.url
        self.source = article.source
        self.publishedAt = article.publishedAt
        self.isBookmarked = false
        self.category = category
    }
}
