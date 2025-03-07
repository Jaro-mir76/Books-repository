//
//  RowView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI

struct  RowView: View {
    var book: Book
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        HStack {
            if let thumbnail = book.bookInfo?.images?.smallThumbnail {
                AsyncImage(url: URL(string: thumbnail)) { image in
                    image.resizable()
                        .scaledToFit()
                        .padding(5)
                } placeholder: {
                    InProgressView()
                }
                .frame(width: 60, height: 75)
            } else {
                Label("no image", systemImage: "nosign")
                    .frame(minWidth: 60, minHeight: 75)
                    .labelStyle(.iconOnly)
                    .padding(5)
            }
            VStack (alignment: .leading){
                Text(book.bookInfo?.title ?? "Book title is missing in DB.")
                    .font(.headline)
                    .lineLimit(2)
                Text(book.bookInfo?.authorsList() ?? "Author is missing in DB.")
                    .font(.subheadline)
                    .lineLimit(2)
            }
            Spacer()
        }
        .background(viewModel.backgroundColor)
    }
}

#Preview {
    RowView(book: GServerResponse.example().first!)
        .environmentObject(ViewModel())
}
