//
//  ArticleRepository.swift
//  ShortNews
//
//  Created by Roshan yadav on 18/09/24.
//

import Foundation
import CoreData

// MARK: - Repository Protocols
protocol ArticleRepositoryProtocol {
    func saveArticles(_ articles: [NewsArticle])
    func update(_ article: NewsArticle)
    func fetchBookmarkedArticles() -> [NewsArticle]
    func fetchArticles(for category: String) -> [NewsArticle]
    func fetchArticles(by url: URL) -> [NewsArticle]
    func cleanUpArticles()
}

// MARK: - ArticleRepository
class ArticleRepository: ArticleRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    private let context: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
        self.context = coreDataManager.getContext()
    }
    
    func saveArticles(_ articles: [NewsArticle]) {
        for article in articles {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", article.url.absoluteString)
            
            do {
                let existingArticles = try context.fetch(fetchRequest)
                if existingArticles.isEmpty {
                    let newArticle = ArticleEntity.getArticleEntity(from: article, context: context)
                    let source = try SourceEntity.fetchOrSave(name: article.source.name, from: context)
                    let category = try CategoryEntity.fetchOrSave(name: article.category, from: context)
                    
                    newArticle.source = source
                    newArticle.category = category
                    newArticle.fetchDate = Date.now
                }
            } catch {
                print("Failed to fetch or create article: \(error.localizedDescription)")
            }
        }
        coreDataManager.saveContext()
    }
    
    func update(_ article: NewsArticle) {
        let predicate = NSPredicate(format: "url == %@", article.url.absoluteString)
        let objects = fetchArticlesObject(for: predicate)
        
        objects.forEach { articleEntity in
            articleEntity.isBookmarked = article.isBookmarked
        }
        coreDataManager.saveContext()
    }
    
    func fetchBookmarkedArticles() -> [NewsArticle] {
        let predicate = NSPredicate(format: "isBookmarked == YES")
        return fetchArticles(for: predicate)
    }
    
    func fetchArticles(for category: String) -> [NewsArticle] {
        let predicate = NSPredicate(format: "category.name == %@", category)
        return fetchArticles(for: predicate)
    }
    
    func fetchArticles(by url: URL) -> [NewsArticle] {
        let predicate = NSPredicate(format: "url == %@", url.absoluteString)
        return fetchArticles(for: predicate)
    }
    
    func cleanUpArticles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEntity.fetchRequest()
        let currentDate = Date.now
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        fetchRequest.predicate = NSPredicate(format: "fetchDate < %@", yesterday as NSDate)
        do {
            let objectsToDelete = try context.fetch(fetchRequest) as! [NSManagedObject]
            objectsToDelete.forEach { context.delete($0) }
            try context.save()
            print("Cleanup successfull, ")
        } catch {
            print("Could not delete old data: \(error.localizedDescription)")
        }
    }
    
    private func fetchArticlesObject(for predicate: NSPredicate) -> [ArticleEntity] {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch articles: \(error.localizedDescription)")
            return []
        }
    }
    
    private func fetchArticles(for predicate: NSPredicate) -> [NewsArticle] {
        let articleEntities = fetchArticlesObject(for: predicate)
        return articleEntities.compactMap { NewsArticle(from: $0) }
    }
}
