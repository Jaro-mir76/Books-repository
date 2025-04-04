//
//  InProgressView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 05.03.2025.
//

import SwiftUI

struct InProgressView: View {
    var body: some View {
        Image(systemName: "progress.indicator")
            .symbolEffect(.variableColor)
    }
}

#Preview {
    InProgressView()
}

