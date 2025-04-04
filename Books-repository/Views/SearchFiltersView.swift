//
//  SearchToolsView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 04/04/2025.
//

import SwiftUI

struct SearchFiltersView: View {
    @Binding var authorSearchText: String
    @Binding var selection: Language
    @EnvironmentObject private var viewModel: ViewModel


    var body: some View {
        VStack {
            HStack (alignment: .bottom) {
                Text("Filters")
                    .font(.callout)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, -5)
            VStack{
                HStack{
                    Text("Author")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                    Spacer()
                    TextField (text: $authorSearchText) {
                        Text("Author name")
                    }
                    .textFieldStyle(.roundedBorder)
                }
                HStack{
                    Text("Language")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $selection) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName)
                                .padding(4)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding(10)
//            .background(viewModel.backgroundColor)
        }
    }
}

#Preview {
    SearchFiltersView(authorSearchText: .constant("Mickiewicz"), selection: .constant(.pl))
        .environmentObject(ViewModel())
}
