//
//  NewsListViewModelTest.swift
//  HeadlinesTests
//
//  Created by Roshan yadav on 18/09/24.
//

import XCTest
import Combine
@testable import Headlines

final class NewsListViewModelTest: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    func test_initialState_isCorrect() {
        let mockNewsService = MockNewsService()
        let mockArticleProvider = MockArticleProvider()
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        
        XCTAssertTrue(viewModel.articles.isEmpty)
        XCTAssertEqual(viewModel.selectedCategory, CategoryType.general.rawValue)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_fetchArticles_success() {
        let mockNewsService = MockNewsService(shouldSucceed: true)
        let mockArticleProvider = MockArticleProvider()
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        let expectation = XCTestExpectation(description: "Articles fetched successfully")

        viewModel.fetchArticles()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { value in
                XCTAssertFalse(viewModel.articles.isEmpty)
                XCTAssertNil(viewModel.errorMessage)
                XCTAssertTrue(mockArticleProvider.saveArticlesCalled)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchArticles_failure() {
        let mockNewsService = MockNewsService(shouldSucceed: false)
        let mockArticleProvider = MockArticleProvider()
        
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        let expectation = XCTestExpectation(description: "Articles fetch failure")
        
        viewModel.fetchArticles()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(viewModel.isLoading == false)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertTrue(mockArticleProvider.fetchArticlesCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_handleSuccess() {
        let mockNewsService = MockNewsService()
        let mockArticleProvider = MockArticleProvider()
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        let articles = Article.getMockDataArray()
        let expectation = XCTestExpectation(description: "Handle Success")
        
        viewModel.handleSuccess(with: articles, for: CategoryType.business.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(viewModel.articles.count, articles.count)
                XCTAssertFalse(viewModel.isLoading)
                XCTAssertNil(viewModel.errorMessage)
                XCTAssertTrue(mockArticleProvider.saveArticlesCalled)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_handleError_withEmptyLocalData() {
        let mockNewsService = MockNewsService()
        let mockArticleProvider = MockArticleProvider()
        mockArticleProvider.mockArticles = []
        
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        
        let expectation = XCTestExpectation(description: "HandleError with Empty Local Data")
        viewModel.handleError(with: "Network Error", for: CategoryType.business.rawValue)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(viewModel.articles.count, 0)
                XCTAssertNotNil(viewModel.errorMessage)
                XCTAssertEqual(viewModel.errorMessage, "Network Error")
                XCTAssertTrue(mockArticleProvider.fetchArticlesCalled)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_handleError_withLocalData() {
        let mockNewsService = MockNewsService(shouldSucceed: false)
        let mockArticleProvider = MockArticleProvider()
        mockArticleProvider.mockArticles = [NewsArticle(from: Article.getMockData() , for: CategoryType.business.rawValue)]
        
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        
        let expectation = XCTestExpectation(description: "HandleError with Local Data")
        viewModel.handleError(with: "Network Error", for: CategoryType.business.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.articles.count, mockArticleProvider.mockArticles.count)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertTrue(mockArticleProvider.fetchArticlesCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetchArticles_doesNotFetchWhenAlreadyLoaded() {
        let mockNewsService = MockNewsService()
        let mockArticleProvider = MockArticleProvider()
        let viewModel = NewsListViewModel(newsService: mockNewsService, articleProvider: mockArticleProvider)
        
        viewModel.articles =  [NewsArticle(from: Article.getMockData() , for: CategoryType.business.rawValue)]
        let expectation = XCTestExpectation(description: "Articles does not fetch when already loaded")
        
        viewModel.fetchArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertFalse(viewModel.isLoading)
                XCTAssertEqual(viewModel.articles.count, 1)
                XCTAssertFalse(mockNewsService.wasFetchCalled)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
}


class MockNewsService: NewsServiceProtocol {
    var shouldSucceed: Bool
    var wasFetchCalled: Bool = false
    
    init(shouldSucceed: Bool = true) {
        self.shouldSucceed = shouldSucceed
    }
    
    func fetchArticles(category: String?) async throws -> [Article] {
        wasFetchCalled = true
        if shouldSucceed {
            return Article.getMockDataArray()
        } else {
            throw APIError.custom("Network Error")
        }
    }
}

extension Article {
    static var mockArticle = Article(
        title: "Breaking Business News",
        subtitle: "Business is booming in 2024",
        imageUrl: URL(string: "https://example.com/image1.jpg"),
        content: "The business sector has seen significant growth...",
        url: URL(string: "https://example.com/article1")!,
        source: Source(name: "Business Insider"),
        publishedAt: Date())
    
    static func getMockDataArray() -> [Article] {
        return [
           mockArticle
            ]
    }
    static func getMockData() -> Article {
        return mockArticle
    }
}

class MockArticleProvider: ArticleRepositoryProtocol {
    var mockArticles: [NewsArticle] = []
    var saveArticlesCalled = false
    var fetchArticlesCalled = false
    
    func saveArticles(_ articles: [NewsArticle]) {
        saveArticlesCalled = true
    }
    
    func fetchArticles(for category: String) -> [NewsArticle] {
        fetchArticlesCalled = true
        return mockArticles
    }

    func fetchBookmarkedArticles() -> [NewsArticle] { return [] }
    func fetchArticles(by url: URL) -> [NewsArticle] { return [] }
    func cleanUpArticles() {}
    func update(_ article: Headlines.NewsArticle) {}
}

