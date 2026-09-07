//
//  AppButton.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/18/26.
//

import SwiftUI

struct AppButton: View {
    private let title: String
    private let style: Style
    private let action: () -> Void
    
    init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.small)
        }
        .buttonStyle(style.buttonStyle)
        .buttonBorderShape(.roundedRectangle(radius: Theme.CornerRadius.large))
    }
}

// MARK: - Previews

#Preview {
    VStack {
        AppButton("Continue") {
            // Do some action
        }
        AppButton("Continue", style: .secondary) {
            // Do some action
        }
    }
    .padding()
}
