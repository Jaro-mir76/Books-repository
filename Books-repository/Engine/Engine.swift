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
    var loading = false
    @Published var alertVisible: Bool = false
    
    var searchParameters: [BooksSearchParameters: BooksSearchParameters] = [:]
    @Published var languageFilter: Language = .notAplicable
    @Published var searchType: SearchType = .textSearch
    
    func searchBooksInterface(searchText: String = "", filterAuthor: String? = nil, filterLanguage: Language? = nil, startIndex: Int? = nil, maxResultsDisplay: Pagination? = nil, sortOrder: SortOrder? = nil, pullMore: Bool = false) {
        
        if pullMore == false {      // it means it is new search and search parameters needs to be initiated with provided value
    //        Inserting parameters into the searchParameters table
            searchParameters = [:]
            searchParameters[.searchText()] = .searchText(searchText)
            if let filterAuthor = filterAuthor {
                searchParameters[.filterAuthor()] = .filterAuthor(filterAuthor)
            }
            if let filterLanguage = filterLanguage {
                searchParameters[.filterLanguage()] = .filterLanguage(filterLanguage)
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
            if !allItems!.isEmpty {
                searchParameters[.startIndex()] = .startIndex(allItems!.count)
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
                    self.loading = false
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
                        self.loading = false
                    }
                }catch {
                    self.error = MyError.parsingProblem
                    self.loading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = MyError.noInternetConnection
                    self.loading = false
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
    
    func coverImageExist (book: Book) -> String? {
        if let smallThumbnail = book.bookInfo?.images?.smallThumbnail {
            return smallThumbnail
        } else if let thumbnail = book.bookInfo?.images?.thumbnail {
            return thumbnail
        }
        return nil
    }
    
    func highResolutionCover (image: String) -> String {
        let hiResCover = image.replacingOccurrences(of: "&zoom=5&", with: "&zoom=10&")
//        let _ = print ("high resolution image url: \(hiResCover)")        //...for debuging/checking if there is not image or it's wrong
        return hiResCover
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
