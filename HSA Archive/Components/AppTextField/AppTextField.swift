//
//  AppTextField.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/21/26.
//

import SwiftUI

struct AppTextField<Style: ShapeStyle>: View {
    @FocusState private var isFocused: Bool
    private let prompt: String
    private let foregroundStyle: Style
    private let loadingText: String?
    private let textField: AnyView
    private let shouldShowDoneButton: Bool
    
    init(
        _ prompt: String,
        placeholder: String,
        text: Binding<String>,
        foregroundStyle: Style = .secondary,
        isLoading: Bool = false
    ) {
        self.prompt = prompt
        self.foregroundStyle = foregroundStyle
        loadingText = isLoading ? text.wrappedValue : nil
        textField = AnyView(
            TextField(
                placeholder,
                text: text
            )
        )
        shouldShowDoneButton = false
    }
    
    init<Format>(
        _ prompt: String,
        placeholder: String,
        value: Binding<Format.FormatInput>,
        format: Format,
        foregroundStyle: Style = .secondary,
        isLoading: Bool = false
    ) where Format: ParseableFormatStyle, Format.FormatOutput == String {
        self.prompt = prompt
        self.foregroundStyle = foregroundStyle
        loadingText = isLoading ? format.format(value.wrappedValue) : nil
        textField = AnyView(
            TextField(
                placeholder,
                value: value,
                format: format
            )
        )
        shouldShowDoneButton = true
    }
    
    var body: some View {
        InputContainer(
            prompt,
            foregroundStyle: foregroundStyle,
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
                    .toolbar { doneKeyboardToolbarButton }
            }
        }
    }
}

// MARK: - Private Views

private extension AppTextField {
    var doneKeyboardToolbarButton: ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .keyboard) {
            if isFocused && shouldShowDoneButton {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
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
