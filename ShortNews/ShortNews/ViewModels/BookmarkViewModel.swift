//
//  BookmarkViewModel.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedArticles: [NewsArticle] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var articleProvider: any ArticleRepositoryProtocol
    
    init(articleProvider: any ArticleRepositoryProtocol = ArticleRepository()) {
        self.articleProvider = articleProvider
        fetchBookmarkedArticles()
    }
    
    func fetchBookmarkedArticles() {
        isLoading = true
        bookmarkedArticles = articleProvider.fetchBookmarkedArticles()
        isLoading = false
    }

}

