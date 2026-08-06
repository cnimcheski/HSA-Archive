//
//  AppToggle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/25/26.
//

import SwiftUI

struct AppToggle: View {
    @Binding private var isOn: Bool
    private let prompt: String
    private let isLoading: Bool
    
    init(
        _ prompt: String,
        isOn: Binding<Bool>,
        isLoading: Bool = false
    ) {
        self._isOn = isOn
        self.prompt = prompt
        self.isLoading = isLoading
    }
    
    var body: some View {
        InputContainer(prompt) {
            Toggle("", isOn: $isOn)
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
