//
//  AppToggle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/25/26.
//

import SwiftUI

struct AppToggle<Style: ShapeStyle>: View {
    @Binding private var isOn: Bool
    private let prompt: String
    private let foregroundStyle: Style
    private let isLoading: Bool
    
    init(
        _ prompt: String,
        isOn: Binding<Bool>,
        foregroundStyle: Style = .secondary,
        isLoading: Bool = false
    ) {
        self._isOn = isOn
        self.prompt = prompt
        self.foregroundStyle = foregroundStyle
        self.isLoading = isLoading
    }
    
    var body: some View {
        InputContainer(prompt, foregroundStyle: foregroundStyle) {
            Toggle("", isOn: $isOn)
                .tint(.accent)
                .disabled(isLoading)
        }
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var isOn = false
    
    PreviewInput {
        AppToggle(
            "Prompt",
            isOn: $isOn,
            isLoading: true
        )
        AppToggle(
            "Prompt",
            isOn: $isOn
        )
    }
}
