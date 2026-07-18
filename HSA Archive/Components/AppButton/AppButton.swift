//
//  AppButton.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/18/26.
//

import SwiftUI

struct AppButton: View {
    private let title: String
    private let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.medium)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: Theme.CornerRadius.large))
    }
}

// MARK: - Previews

#Preview {
    AppButton("Continue") {
        print("Do some action!")
    }
}
