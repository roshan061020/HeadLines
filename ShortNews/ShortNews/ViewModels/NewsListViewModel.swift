//
//  NewsListViewModel.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

class NewsListViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var selectedCategory: String = CategoryType.general.rawValue
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private var articleProvider: any ArticleRepositoryProtocol
    private var newsService: any NewsServiceProtocol
    
    // Data injection for batter testing
    init(newsService: any NewsServiceProtocol = NewsService(),
         articleProvider: any ArticleRepositoryProtocol = ArticleRepository()) {
        self.newsService = newsService
        self.articleProvider = articleProvider
    }

    func fetchArticles() {
        guard articles.isEmpty else {return}
        isLoading = true
        
        Task { [weak self] in
            // self should be present else return as view/view model does not exist any more.
            guard let strongSelf = self else {return}
            do {
                let fetchedArticles = try await strongSelf.newsService.fetchArticles(category: strongSelf.selectedCategory)
                strongSelf.handleSuccess(with: fetchedArticles,
                                         for: strongSelf.selectedCategory)
            } catch {
                strongSelf.handleError(with: error.localizedDescription,
                                       for: strongSelf.selectedCategory)
            }
        }
    }
    
    func handleSuccess(with articles: [Article], for category: String) {
        DispatchQueue.main.async { [weak self] in
            let newsArticles = articles.map{NewsArticle(from: $0, for: category)}
            // Save articles to Core Data for offline access
            self?.articleProvider.saveArticles(newsArticles)
            self?.articles = newsArticles
            self?.isLoading = false
            self?.errorMessage = nil
        }
    }
    
    func handleError(with message: String, for category: String) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.isLoading = false
            // Load articles from Core Data
            strongSelf.articles = strongSelf.articleProvider.fetchArticles(for: category)
            if strongSelf.articles.isEmpty {
                strongSelf.errorMessage = message
            } else {
                strongSelf.errorMessage = nil
            }
        }
    }
}
