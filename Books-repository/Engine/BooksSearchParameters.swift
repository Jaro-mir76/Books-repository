//
//  BooksSearchParameters.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 08/03/2025.
//

import Foundation

// Some GoogleBooks API params
// searchKey = "?q="
// searchKeyAuthor = "+inauthor:"
// languageFilter = "&langRestrict=cs"
// startIndexString = "&startIndex="
// maxResultsString = "&maxResults="
// sortFromNewest = "&orderBy=newest"

enum BooksSearchParameters: CaseIterable, Hashable {
    static let allCases: [Self] = [
        .searchText(),
        .searchAuthor(),
        .languageFilter(),
        .startIndex(),
        .maxResults(),
        .sortOrder()
    ]
    case searchText(String? = nil)
    case searchAuthor(String? = nil)
    case languageFilter(Language? = nil)
    case startIndex(Int? = nil)
    case maxResults(Pagination? = nil)
    case sortOrder(SortOrder? = nil)
    
//    var mandatory: Bool { // this is prepared for anothe functionality which is not yet implemented
//        switch self {
//        case .searchText:
//            return true
//        case .searchAuthor:
//            return false
//        case .languageFilter:
//            return false
//        case .startIndex:
//            return false
//        case .maxResults:
//            return false
//        case .sortOrder:
//            return false
//        }
//    }
    
    var KeyValueString: String {
        switch self {
        case .searchText(let text):
            if text != nil {
                return "?q=" + text!
            } else {
                return "?q="
            }
        case .searchAuthor(let text):
            if text != nil {
                return "+inauthor:" + text!
            } else {
                return ""
            }
        case .languageFilter(let language):
            if language != nil {
                return "&langRestrict=" + language!.rawValue
            } else {
                return ""
            }
        case .startIndex(let number):
            if number != nil {
                return "&startIndex=" + String(number!)
            } else {
                return ""
            }
        case .maxResults(let pagination):
            if pagination != nil {
                return "&maxResults=" + pagination!.rawValue
            } else {
                return ""
            }
        case .sortOrder(let sortOrder):
            if sortOrder != nil {
                return "&orderBy=" + sortOrder!.rawValue
            } else {
                return ""
            }
        }
    }
    
    var rawValue: String {
        switch self {
        case .searchText(let text):
            if text != nil {
                return text!
            } else {
                return ""
            }
        case .searchAuthor(let text):
            if text != nil {
                return text!
            } else {
                return ""
            }
        case .languageFilter(let language):
            if language != nil {
                return language!.rawValue
            } else {
                return ""
            }
        case .startIndex(let number):
            if number != nil {
                return String(number!)
            } else {
                return ""
            }
        case .maxResults(let pagination):
            if pagination != nil {
                return pagination!.rawValue
            } else {
                return ""
            }
        case .sortOrder(let sortOrder):
            if sortOrder != nil {
                return sortOrder!.rawValue
            } else {
                return ""
            }
        }
    }
}

enum Language: String, CaseIterable, Identifiable, Codable {
    case pl
    case cs
    case en
    case es
    case notAplicable = ""
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        switch self {
        case .pl:
            return "Polish"
        case .cs:
            return "Czech"
        case .en:
            return "English"
        case .es:
            return "Spanish"
        case .notAplicable:
            return "---"
        }
    }
}

enum Pagination: String {
    case ten = "10"
    case twenty = "20"
    case thirty = "30"
    case fourty = "40"
}

enum SortOrder: String {
    case newest = "newest"
    case relevance = "relevance"
}
