//
//  SearchType.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 10/03/2025.
//

import Foundation

enum SearchType: String, CaseIterable, Identifiable, Codable {
    case textSearch
    case byAuthor
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        case .textSearch:
            return "text"
        case .byAuthor:
            return "author"
        }
    }
}
