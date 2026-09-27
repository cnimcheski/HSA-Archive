//
//  InputContainer.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import SwiftUI

struct InputContainer<T: View, Style: ShapeStyle>: View {
    private let prompt: String
    private let foregroundStyle: Style
    private let action: () -> Void
    private let content: T
    
    init(
        _ prompt: String,
        foregroundStyle: Style,
        action: @escaping () -> Void = {},
        @ViewBuilder content: () -> T
    ) {
        self.prompt = prompt
        self.foregroundStyle = foregroundStyle
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Text(prompt)
                .foregroundStyle(foregroundStyle)
            Spacer()
            content
        }
        .padding(.vertical, Theme.Spacing.xSmall)
        .contentShape(.rect)
        .onTapGesture(perform: action)
    }
}

// MARK: - Previews

#Preview {
    InputContainer("Title", foregroundStyle: .secondary) {
        Text("Content")
    }
    .padding()
}
