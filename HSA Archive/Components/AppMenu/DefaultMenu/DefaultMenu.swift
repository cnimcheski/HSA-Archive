//
//  DefaultMenu.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/1/25.
//

import SwiftUI

struct DefaultMenu<Content: View>: View {
    @Binding private var selection: Selection
    private let prompt: String
    private let isLoading: Bool
    private let content: Content
    
    init(
        _ prompt: String,
        selection: Binding<Selection>,
        isLoading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.prompt = prompt
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        Menu {
            Picker("", selection: $selection) {
                content
            }
        } label: {
            InputContainer(prompt) {
                MenuLabel(selection: selection)
                    .redactedShimmer(isShimmering: isLoading)
            }
        }
        .tint(.primary)
        .disabled(isLoading)
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var selection = Selection.mock
    let items = ["", "hi", "hello"]
    
    PreviewInput {
        DefaultMenu(
            "Prompt",
            selection: $selection,
            isLoading: true
        ) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .tag(item)
            }
        }
        DefaultMenu("Prompt", selection: $selection) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .tag(item)
            }
        }
    }
}
