//
//  Books_repositoryApp.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 03.03.2025.
//

import SwiftUI

@main
struct Books_repositoryApp: App {
    
    @StateObject var engine = Engine()
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            SearchView()
//                .padding()
                .environmentObject(engine)
                .environmentObject(viewModel)
        }
    }
}
