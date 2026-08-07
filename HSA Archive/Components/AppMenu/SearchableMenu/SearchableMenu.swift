//
//  SearchableMenu.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/4/25.
//

import SwiftUI

struct SearchableMenu: View {
    private let prompt: String
    private let selection: Selection
    private let isLoading: Bool
    private let action: () -> Void
    
    /// Provides a custom Menu with action callback to be used to present a `SelectionView`.
    init(
        _ prompt: String,
        selection: Selection,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.prompt = prompt
        self.selection = selection
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        InputContainer(prompt) {
            guard !isLoading else { return }
            action()
        } content: {
            MenuLabel(selection: selection)
                .redactedShimmer(isShimmering: isLoading)
        }
    }
}

#Preview {
    PreviewInput {
        SearchableMenu("Title", selection: .mock, isLoading: true) {
            // Do some action
        }
        SearchableMenu("Title", selection: .mock) {
            // Do some action
        }
    }
}
