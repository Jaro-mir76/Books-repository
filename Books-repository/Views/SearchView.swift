//
//  SearchView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var alertVisible: Bool = false
    @EnvironmentObject private var engine: Engine
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            HStack {
                TextField (text: $searchText) {
                    Text("Search by author")
                }
                .textFieldStyle(.roundedBorder)
                Button("Search") {
                    engine.searchValue = searchText
                    engine.searchBooks()
                }
                .disabled(searchText.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(5)
            .background(viewModel.backgroundColor)
            
            ScrollView {
                LazyVStack (alignment: .center) {
                    if let books = engine.allItems {
                        ForEach(books, id: \.id) { book in
                            NavigationLink(value: book.self) {
                                RowView(book: book)
                            }
                        }
                            VStack (alignment: .center) {
                                Text("Displayed books: \(books.startIndex+1) - \(books.count)")
                                    .font(.caption)
                                Button("Show more") {
                                    engine.searchBooks(startIndex: books.count, newSearch: false)
                                }
                            }
                    }else {
                        EmptyView()
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
        .onChange(of: engine.error){ _, newValue in
            self.alertVisible = newValue != nil
        }
        .alert(isPresented: $alertVisible, error: engine.error) { _ in
            Button("OK", role: .cancel) {
                engine.error = nil
                self.alertVisible = false
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Unknown error")
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(Engine.example())
        .environmentObject(ViewModel())
}
