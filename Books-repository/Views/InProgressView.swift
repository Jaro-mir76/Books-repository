//
//  InProgressView.swift
//  Books-repository
//
//  Created by Jaromir Jagieluk on 05.03.2025.
//

import SwiftUI

struct InProgressView: View {
    var body: some View {
        Label("Load in progress", systemImage: "progress.indicator")
            .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
            .labelStyle(.iconOnly)
    }
}

#Preview {
    InProgressView()
}
