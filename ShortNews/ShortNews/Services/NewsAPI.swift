//
//  NewsAPI.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

//FIXME: This could be converted to builder to support more detailed configurations
enum NewsAPI {
    static func buildURL(for category: String?, apiKey: String) -> URL {
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")!
        var queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        
        if let category = category, !category.isEmpty {
            queryItems.append(URLQueryItem(name: "category", value: category))
        } else {
            queryItems.append(URLQueryItem(name: "country", value: "us")) // Default to US news
        }
        
        components.queryItems = queryItems
        return components.url!
    }
}


// MARK: - NewsServiceProtocol and NewsService
protocol NewsServiceProtocol {
    func fetchArticles(category: String?) async throws -> [Article]
}


// Responsible for fetching news Articles by category
final class NewsService: NewsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let apiKey: String?
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         keyProvider: keyDataProvider = PlistDataProvider()) {
        self.networkService = networkService
        apiKey = keyProvider.getConfigStringValue(for: "key")
    }
    
    func fetchArticles(category: String?) async throws -> [Article] {
        guard let apiKey else {
            fatalError("No Api key found")
        }
        
        let url = NewsAPI.buildURL(for: category,apiKey: apiKey)
        do {
            let response: NewsAPIResponse = try await networkService.fetchData(from: url)
            // Filter out the article which are removed. 
            return response.articles.filter{$0.url != URL(string: "https://removed.com")}
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.custom("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}


