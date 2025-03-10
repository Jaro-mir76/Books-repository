//
//  Engine.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04.03.2025.
//

import Foundation
import SwiftUI

class Engine: ObservableObject {
    let bookSearchURL = "https://www.googleapis.com/books/v1/volumes"
    let googlePlayURL = "https://play.google.com/store/books/details?id="
    var totalItemsFound: Int = 0
    @Published var allItems: [Book]? = nil
    @Published var error: MyError? = nil
    var isThereMore: Bool = false
    var searchParameters: [BooksSearchParameters: BooksSearchParameters] = [:]
    
    func searchBooksInterface(searchText: String = "", searchByAuthor: String? = nil, filterbyLanguage: Language? = nil, startIndex: Int? = nil, maxResultsDisplay: Pagination? = nil, sortOrder: SortOrder? = nil) {
        
        if startIndex == nil {      // it means it is new search and search parameters needs to be initiated with provided value
    //        Inserting parameters into the searchParameters table
            searchParameters = [:]
            searchParameters[.searchText()] = .searchText(searchText)
            if let searchByAuthor = searchByAuthor {
                searchParameters[.searchAuthor()] = .searchAuthor(searchByAuthor)
            }
            if let filterbyLanguage = filterbyLanguage {
                searchParameters[.languageFilter()] = .languageFilter(filterbyLanguage)
            }
            if let startIndex = startIndex {
                searchParameters[.startIndex()] = .startIndex(startIndex)
            }
            if let maxResultsDisplay = maxResultsDisplay {
                searchParameters[.maxResults()] = .maxResults(maxResultsDisplay)
            }
            if let sortOrder = sortOrder {
                searchParameters[.sortOrder()] = .sortOrder(sortOrder)
            }
        } else {
            if let startIndex = startIndex {
                searchParameters[.startIndex()] = .startIndex(startIndex)
            }
        }
        guard let searchQueryURL = prepareSearchQueryURL() else {
            error = MyError.badURL
            return
        }
        searchBooks(searchQueryUrl: searchQueryURL)
    }
    
    func searchBooks(searchQueryUrl: URL) {
        let task = URLSession.shared.dataTask(with: searchQueryUrl) { data, response, error in
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
                    DispatchQueue.main.async { [self] in
                        if answer.items?.count == 0 || answer.items == nil {    // if nothing new found show info and exit
                            self.error = MyError.nothingFound
                            return
                        }
                        if let _ = self.searchParameters[.startIndex()] {   // if .startIndex paramater exist then we are pulling more info and results have to be added to existing
                            self.allItems! += answer.items!
                        } else {    // if .startIndex doesn't exist it means this is new search
                            self.allItems = answer.items
                            if let totalItemsCount = self.allItems?.count, let totalItemsFound = answer.totalItems {
                                self.isThereMore = totalItemsCount < totalItemsFound
                            }
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
    
    func prepareSearchQueryURL() -> URL? {
        var stringForURL = bookSearchURL
        for parameter in BooksSearchParameters.allCases {
            if let parameter = searchParameters[parameter]?.KeyValueString {
                stringForURL += parameter
            }
        }
        if let url = URL(string: stringForURL) {
            return url
        } else {
            return nil
        }
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
