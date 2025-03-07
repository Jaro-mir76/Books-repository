//
//  BookInfo.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04.03.2025.
//

import Foundation

struct BookInfo: Codable, Hashable {
    let title: String?
    let authors: [String]?
    let publishedDate: String?
    let desc: String?
    let images: CoverImages?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case publishedDate
        case desc = "description"
        case images = "imageLinks"
    }
    
    func authorsList() -> String? {
        var authorsList: String? = nil
        if let authors = authors {
            for author in authors {
                if authorsList == nil {
                    authorsList = author
                }else {
                    authorsList! += ", " + author
                }
            }
        }
        return authorsList
    }
}
