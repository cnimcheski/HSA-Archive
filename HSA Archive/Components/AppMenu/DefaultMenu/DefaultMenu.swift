//
//  DefaultMenu.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/1/25.
//

import SwiftUI

struct DefaultMenu<Content: View, Style: ShapeStyle>: View {
    @Binding private var selection: Selection
    private let prompt: String
    private let foregroundStyle: Style
    private let isLoading: Bool
    private let content: Content
    
    init(
        _ prompt: String,
        selection: Binding<Selection>,
        foregroundStyle: Style = .secondary,
        isLoading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.prompt = prompt
        self.foregroundStyle = foregroundStyle
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        Menu {
            Picker("", selection: $selection) {
                content
            }
        } label: {
            InputContainer(prompt, foregroundStyle: foregroundStyle) {
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
