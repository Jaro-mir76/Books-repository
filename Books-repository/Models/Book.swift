//
//  Book.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04.03.2025.
//
import Foundation

struct Book: Codable, Hashable {
    let myID = UUID()
    let id: String?
    let bookInfo: BookInfo?
    
    enum CodingKeys: String, CodingKey {
        case myID
        case id
        case bookInfo = "volumeInfo"
    }
}
