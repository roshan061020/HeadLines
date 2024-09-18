//
//  NewsDetailViewModel.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

class NewsDetailViewModel: ObservableObject {
    @Published var article: NewsArticle?
    @Published var isLoading: Bool = false

    private var articleProvider: any ArticleRepositoryProtocol
    
    init(articleProvider: any ArticleRepositoryProtocol = ArticleRepository()) {
        self.articleProvider = articleProvider
    }
    
    func fetchArticle(for articleUrl: URL) {
        isLoading = true
        
        // Fetch from Core Data as complete article is already fetched and stored in core data on list view
        let article = articleProvider.fetchArticles(by: articleUrl)
        self.article = article.first
        isLoading = false
    }
    
    func toggleBookmark() {
        guard var article = article else { return }
        article.isBookmarked.toggle()
        articleProvider.update(article)
        fetchArticle(for: article.url)
    }
}
