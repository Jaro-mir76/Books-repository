//
//  LanguageFilterView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 10/03/2025.
//

import SwiftUI

struct LanguageFilterView: View {
    @Binding var selection: Language

        var body: some View {
            HStack{
                Text("Filter by languege")
                    .font(.footnote)
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
}

#Preview {
    LanguageFilterView(selection: .constant(.pl))
}
