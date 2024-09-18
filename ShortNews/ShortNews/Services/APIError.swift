//
//  APIError.swift
//  ShortNews
//
//  Created by Roshan yadav on 17/09/24.
//

import Foundation


enum APIError: Error, LocalizedError {
    case networkError(Error)
    case serverError(Int) // HTTP status code
    case decodingError(Error)
    case invalidResponse
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .custom(let message):
            return message
        }
    }
}
