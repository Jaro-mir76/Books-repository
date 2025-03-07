//
//  ServerResponse.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04.03.2025.
//

import Foundation

class GServerResponse: Codable, ObservableObject {
    var kind: String?
    var totalItems: Int?
    var items: [Book]?
    
    init(kind: String? = nil, totalItems: Int? = nil, items: [Book]? = nil) {
        self.kind = kind
        self.totalItems = totalItems
        self.items = items
    }
    
    static func example() -> [Book] {
        let images = CoverImages(smallThumbnail: "http://books.google.com/books/content?id=6vYlRW-OMd4C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api", thumbnail: "http://books.google.com/books/content?id=6vYlRW-OMd4C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
        let bookInfo1 = BookInfo(title: "Big THING", authors: ["John Wick", "Jan Kowalski"], publishedDate: nil, desc: "This is small description of this \"real\" book that is needed for Preview purposes.", images: images)
        let bookInfo2 = BookInfo(title: "SMALL thing", authors: ["Some Oneimportant"], publishedDate: nil, desc: "This is small description of this \"real\" book that is needed for Preview purposes.", images: images)
        let bookInfo3 = BookInfo(title: "Hmmmm..... and very long titleeeeeeeeeeeeeee", authors: ["Jan Kowalski"], publishedDate: nil, desc: "This is small description of this \"real\" book that is needed for Preview purposes.", images: images)
        let book1 = Book(id: "123", bookInfo: bookInfo1)
        let book2 = Book(id: "1235", bookInfo: bookInfo2)
        let book3 = Book(id: "12354", bookInfo: bookInfo3)
        return [book1, book2, book3]
    }
}
