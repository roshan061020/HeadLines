//
//  NetworkService.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation

// MARK: - Generic Network Layer 
protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }catch {
            throw APIError.decodingError(error)
        }
    }
}

