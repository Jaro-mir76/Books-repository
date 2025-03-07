//
//  CoverView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI



struct CoverView: View {
    var image: String
    @State private var alertVisible: Bool = false
    @EnvironmentObject private var engine: Engine
    
    var body: some View {
        VStack{
            Text("Swipe down to close.")
                .padding(10)
            Spacer()
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .scaledToFit()
                    .border(Color.gray, width: 1)
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
            } placeholder: {
                InProgressView()
            }
            .padding(5)
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
            Spacer()
        }
    }
}

#Preview {
    CoverView(image: GServerResponse.example().first!.bookInfo!.images!.thumbnail!)
        .environmentObject(Engine())
}
