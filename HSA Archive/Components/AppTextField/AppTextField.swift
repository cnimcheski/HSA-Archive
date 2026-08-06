//
//  AppTextField.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/21/26.
//

import SwiftUI

struct AppTextField: View {
    @FocusState private var isFocused: Bool
    private let prompt: String
    private let loadingText: String?
    private let textField: AnyView
    
    init(
        _ prompt: String,
        placeholder: String,
        text: Binding<String>,
        isLoading: Bool = false
    ) {
        self.prompt = prompt
        loadingText = isLoading ? text.wrappedValue : nil
        textField = AnyView(
            TextField(
                placeholder,
                text: text
            )
        )
    }
    
    init<Format>(
        _ prompt: String,
        placeholder: String,
        value: Binding<Format.FormatInput>,
        format: Format,
        isLoading: Bool = false
    ) where Format: ParseableFormatStyle, Format.FormatOutput == String {
        self.prompt = prompt
        loadingText = isLoading ? format.format(value.wrappedValue) : nil
        textField = AnyView(
            TextField(
                placeholder,
                value: value,
                format: format
            )
        )
    }
    
    var body: some View {
        InputContainer(
            prompt,
            action: { isFocused = true }
        ) {
            // Show a Text view when isLoading is true so that the shimmer matches other inputs
            if let loadingText {
                Text(loadingText)
                    .redactedShimmer()
            } else {
                textField
                    .multilineTextAlignment(.trailing)
                    .focused($isFocused)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var text = "Target Inc."
    
    PreviewInput {
        AppTextField(
            "Merchant",
            placeholder: "Merchant name...",
            text: $text,
            isLoading: false
        )
        AppTextField(
            "Merchant",
            placeholder: "Merchant name...",
            text: $text,
            isLoading: true
        )
    }
}
