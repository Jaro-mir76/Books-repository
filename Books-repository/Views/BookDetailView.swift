//
//  BookDetailView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book
    @State private var coverViewVisible: Bool = false
    @State private var alertVisible: Bool = false
    @EnvironmentObject private var engine: Engine
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let thumbnail = engine.coverImageExist(book: book) {
                    AsyncImage(url: URL(string: thumbnail)) { image in
                        Button(action: {
                            if let _ = book.bookInfo?.images?.thumbnail {
                                coverViewVisible.toggle()
                            }
                        }) {
                            ZStack(alignment: .bottomTrailing) {
                                image.resizable()
                                    .scaledToFit()
                                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                                Rectangle()
                                    .fill(Color.white.opacity(0.5))
                                    .clipShape(.buttonBorder)
                                    .frame(width: 79, height: 75)
                                Label("Show large cover image.", systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 60))
                            }
                            .border(Color.blue, width: 1)
                        }
                    } placeholder: {
                        InProgressView()
                    }
                    .frame(idealHeight: 300)
                } else {
                    Label("no image", systemImage: "nosign")
                        .frame(minWidth: 60, minHeight: 75)
                        .labelStyle(.iconOnly)
                        .padding(5)
                        .background(.gray)
                        .shadow(color: .black, radius: 10, x: 5, y: 5)
                }
                VStack {
                Text(book.bookInfo?.title ?? "Title is missing in DB.")
                        .multilineTextAlignment(.center)
                    .padding(5)
                    .font(.title)
                        Text(book.bookInfo?.authorsList() ?? "Author is missing in DB.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        Text(book.bookInfo?.publishedDate ?? "Publishing date is missing in DB.")
                        .multilineTextAlignment(.center)
                        Text(book.bookInfo?.desc ?? "Description of this book is missing in DB.")
                        .multilineTextAlignment(.center)
                    }
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
        .sheet(isPresented: $coverViewVisible) {
            if let image = engine.coverImageExist(book: book) {
                
                CoverView(image: engine.highResolutionCover(image: image))
            }
        }
        HStack {
            Button("Go to GooglePlay for more details.") {
                engine.openGooglePlayWebPage(bookId: book.id!)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    BookDetailView(book: GServerResponse.example().first!)
        .environmentObject(ViewModel())
        .environmentObject(Engine())
}
