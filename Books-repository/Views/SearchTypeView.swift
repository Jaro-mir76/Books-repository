//
//  SearchTypeView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 10/03/2025.
//

import SwiftUI

struct SearchTypeView: View {
    @Binding var searchType: SearchType

        var body: some View {
            HStack{
                Text("Search")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                Spacer()
                Picker("", selection: $searchType) {
                    ForEach(SearchType.allCases) { searchType in
                        Text(searchType.displayName)
                            .padding(4)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .tag(searchType)
                    }
                }
                .pickerStyle(.menu)
            }
        }
}

#Preview {
    SearchTypeView(searchType: .constant(.textSearch))
}
