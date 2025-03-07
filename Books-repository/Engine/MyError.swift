//
//  MyError.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 07/03/2025.
//

import Foundation

enum MyError: Error, LocalizedError {
    case badURL
    case badServerResponse
    case parsingProblem
    case noInternetConnection
    case nothingFound
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Bad URL"
        case .badServerResponse:
            return "Sorry, bad server response"
        case .parsingProblem:
            return "Sorry, there is parsing problem"
        case .noInternetConnection:
            return "No internet connection"
        case .nothingFound:
            return "No records found"
        case .unknown:
            return "Unknown error"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .badURL:
            return "Check your URL"
        case .badServerResponse:
            return "Try again later"
        case .parsingProblem:
            return "Try different search"
        case .noInternetConnection:
            return "Check your internet connection and try again"
        case .nothingFound:
            return "Try to different search"
        case .unknown:
            return "Unknown error"
        }
    }
}
