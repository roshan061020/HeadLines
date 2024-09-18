//
//  NewsServiceTests.swift
//  HeadlinesTests
//
//  Created by Roshan yadav on 18/09/24.
//

import XCTest
@testable import Headlines

class NewsServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var mockKeyDataProvider: MockKeyDataProvider!
    var newsService: NewsService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockKeyDataProvider = MockKeyDataProvider(apiKey: "test_api_key")
        newsService = NewsService(networkService: mockNetworkService, keyProvider: mockKeyDataProvider)
    }

    override func tearDown() {
        mockNetworkService = nil
        mockKeyDataProvider = nil
        newsService = nil
        super.tearDown()
    }

    func test_fetchArticles_success() async throws {
         
        let expectedArticles = [Article.mockArticle]
        mockNetworkService.mockResponse = NewsAPIResponse(articles: expectedArticles)
        
        // Act
        let articles = try await newsService.fetchArticles(category: "business")
        
        // Assert
        XCTAssertEqual(articles.count, expectedArticles.count)
        XCTAssertEqual(articles.first?.title, expectedArticles.first?.title)
    }
    
    func test_fetchArticles_throwsAPIError() async {
         
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = APIError.custom("Test API error")
         
        do {
            _ = try await newsService.fetchArticles(category: "business")
            XCTFail("Expected APIError to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error.localizedDescription, "Test API error")
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func test_fetchArticles_throwsNetworkError() async {
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = URLError(.badServerResponse) // Simulate network error
        
        do {
            _ = try await newsService.fetchArticles(category: "business")
            XCTFail("Expected APIError to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error.localizedDescription, "An unexpected error occurred: The operation couldn’t be completed. (NSURLErrorDomain error -1011.)")
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var mockResponse: NewsAPIResponse?
    var shouldThrowError = false
    var errorToThrow: Error?
    
    func fetchData<T>(from url: URL) async throws -> T where T : Decodable {
        if shouldThrowError, let errorToThrow {
            throw errorToThrow
        }
        
        guard let response = mockResponse as? T else {
            throw APIError.custom("Mocked response not found")
        }
        
        return response
    }
}


class MockKeyDataProvider: keyDataProvider {
    private let apiKey: String?
    
    init(apiKey: String?) {
        self.apiKey = apiKey
    }
    
    func getConfigStringValue(for key: String) -> String? {
        return apiKey
    }
}
