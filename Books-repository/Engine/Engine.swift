//
//  Engine.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04.03.2025.
//

import Foundation
import SwiftUI

class Engine: ObservableObject {
    let bookInfoURL = "https://www.googleapis.com/books/v1/volumes"
    let googlePlayURL = "https://play.google.com/store/books/details?id="
    let searchKey = "?q="
    var searchValue: String = "apple"
    let searchKeyAuthor = "?inauthor:"
    let languageFilter = "&langRestrict=cs"
    var startIndexString = "&startIndex="
    var maxResultsString = "&maxResults="
    let sortFromNewest = "&orderBy=newest"
    var totalItemsFound: Int = 0
    @Published var allItems: [Book]? = nil
    @Published var error: MyError? = nil
    var isThereMore: Bool = false
    
    func searchBooks(startIndex: Int = 0, newSearch: Bool = true) {
        guard let url = URL(string: bookInfoURL + searchKey + searchKeyAuthor + searchValue + languageFilter + startIndexString + String(startIndex)) else {
            error = MyError.badURL
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                DispatchQueue.main.async {
                    self.error = MyError.badServerResponse
                }
                return
            }
            let decoder = JSONDecoder()
            if let data = data{
                do {
                    let answer = try decoder.decode(GServerResponse.self, from: data)
                    DispatchQueue.main.async {
                        if newSearch {
                            self.allItems = answer.items
                            if answer.items?.count == 0 || answer.items == nil {
                                self.error = MyError.nothingFound
                                return
                            }
                            if let totalItemsCount = self.allItems?.count, let totalItemsFound = answer.totalItems {
                                self.isThereMore = totalItemsCount < totalItemsFound
                            }
                        }else if self.allItems != nil, let items = answer.items {
                            self.allItems! += items
                        }
                    }
                }catch {
                    self.error = MyError.parsingProblem
                }
            } else {
                DispatchQueue.main.async {
                    self.error = MyError.noInternetConnection
                }
            }
        }
        task.resume()
    }
    
    func openGooglePlayWebPage(bookId: String) {
        if let url = URL(string: googlePlayURL + bookId), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func example() -> Engine {
        let engine = Engine()
        engine.allItems = GServerResponse.example()
        return engine
    }
}
