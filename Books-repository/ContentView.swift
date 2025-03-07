//
//  ContentView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ViewModel
    var body: some View {
        SearchView()
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(Engine.example())
        .environmentObject(ViewModel())
}
