//
//  SearchFilterIndicationView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 01/04/2025.
//

import SwiftUI

struct SearchFilterIndicationView: View {
//    @EnvironmentObject private var engine: Engine
    var filterAuthor: String
    var filterLanguage: Language

    var body: some View {
        HStack {
                Text("Active filters:")
                    .font(.caption2)
                    .foregroundColor(.gray)
            if filterAuthor != "" {
                Text("author:")
                    .font(.caption2)
                    .foregroundColor(.blue)
                Text(filterAuthor)
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.blue)
            }
            if filterLanguage != .notAplicable {
                Text("language")
                    .font(.caption2)
                    .foregroundColor(.blue)
                Text(filterLanguage.displayName)
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    SearchFilterIndicationView(filterAuthor: "Miłosz", filterLanguage: .es)
        .environmentObject(Engine())
}
