//
//  ArticleEntityExtensions.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation
import CoreData

extension ArticleEntity {
    static func getArticleEntity(from article: NewsArticle, context: NSManagedObjectContext) -> ArticleEntity {
        let newArticle = ArticleEntity(context: context)
        newArticle.id = article.id
        newArticle.title = article.title
        newArticle.subtitle = article.subtitle
        newArticle.imageUrl = article.imageUrl?.absoluteString
        newArticle.content = article.content
        newArticle.url = article.url.absoluteString
        newArticle.publishedAt = article.publishedAt
        newArticle.isBookmarked = article.isBookmarked
        return newArticle
    }
}
