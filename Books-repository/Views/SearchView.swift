//
//  SearchView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI
import Foundation

struct SearchView: View {
    @State private var searchText = ""
    @State private var filterAuthor = ""
    @State private var filterLanguage: Language = .notAplicable
    @State private var searchType: SearchType = .textSearch
    @State private var toolsVisible: Bool = false
    @EnvironmentObject private var engine: Engine
    @EnvironmentObject private var viewModel: ViewModel
    
    @State private var offset = CGSize.zero
    @State private var lastVisible = false
    @State private var lastWasThere = false
    @State private var beginingOfPullUpGesture = false
    @State private var firstGesture = true
    @State private var startTransparency: CGFloat = 0
    @FocusState private var searchFocused: Bool
    
    var body: some View {        
        NavigationStack {
            VStack {
                    HStack {
                        TextField (text: $searchText) {
                            Text("Search text")
                        }
                        .focused($searchFocused)
                        .task({
                            self.searchFocused = true
                        })
                        .textFieldStyle(.roundedBorder)
                        Button("Search") {
                            engine.searchBooksInterface(searchText: searchText, filterAuthor: filterAuthor ,filterLanguage: filterLanguage)
                            searchFocused = false
                            withAnimation {
                                toolsVisible = false
                            }
                        }
                        .disabled(searchText.isEmpty && filterAuthor == "")
                        .buttonStyle(.borderedProminent)
                        Button(action: {
                            withAnimation {
                                toolsVisible.toggle()
                            }
                        }) {
                            Image(systemName: "gear")
                        }
                    }
                    .padding(5)
                    .background(viewModel.backgroundColor)
                
                    if toolsVisible {
                        SearchFiltersView(authorSearchText: $filterAuthor, selection: $filterLanguage)
                    } else if filterAuthor != "" || filterLanguage != .notAplicable {
                        SearchFilterIndicationView(filterAuthor: filterAuthor, filterLanguage: filterLanguage)
                    }
            }
            
            ScrollView {
                LazyVStack (alignment: .center) {
                    if let books = engine.allItems {
                        ForEach(books, id: \.id) { book in
                            NavigationLink(value: book.self) {
                                RowView(book: book)
                            }
                        }
                            VStack (alignment: .center) {
                                Text("Books: \(books.startIndex+1) - \(books.count)")
                                    .font(.caption)
                            }
                        if !engine.loading {
                            Text("Pull up to load more")
                                .opacity(lastWasThere ? viewModel.opacityHelper(double:  startTransparency - offset.height) : 0)
                        } else {
                            Text("Loading...")
                        }
                    } else {
                        EmptyView()
                    }
                }
                .scrollTargetLayout()
            }
            .onScrollTargetVisibilityChange(idType: String.self, threshold: 0.5, { value in
                if engine.allItems?.last?.id == value.last {
                    lastVisible = true
                } else {
                    lastVisible = false
                }
            })
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
            .simultaneousGesture(dragGesture())
        }
        .onChange(of: engine.error){ _, newValue in
            engine.alertVisible = newValue != nil
        }
        .alert(isPresented: $engine.alertVisible, error: engine.error) { _ in
            Button("OK", role: .cancel) {
                engine.error = nil
                engine.alertVisible = false
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Unknown error")
        }
    }
    
    func dragGesture() -> some Gesture {
        let dragGesture = DragGesture()
            .onChanged { value in
                if firstGesture, lastVisible {
                    lastWasThere = true
                }
                offset = value.translation
                if !beginingOfPullUpGesture {
                    startTransparency = offset.height
                }
                if lastWasThere, lastVisible, offset.height < -50 {
                    beginingOfPullUpGesture = true
                    if offset.height - startTransparency < -100 {
                        if engine.loading == false {
                            engine.loading = true
                            engine.searchBooksInterface(pullMore: true)
                        }
                    }
                } else {
                    beginingOfPullUpGesture = false
                }
                firstGesture = false
            }
            .onEnded { value in
                withAnimation {
                    offset = .zero
                    startTransparency = .zero
                    if lastVisible {
                        lastWasThere = true
                    } else {
                        lastWasThere = false
                    }
                }
                firstGesture = true
            }
        return dragGesture
    }
}

#Preview {
    SearchView()
        .environmentObject(Engine.example())
        .environmentObject(ViewModel())
}
