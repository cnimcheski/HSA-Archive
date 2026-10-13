//
//  AppLink.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/10/26.
//

import SwiftUI

struct AppLink: View {
    private let title: String
    private let destination: URL
    private let style: AppButtonStyle
    
    init(_ title: String, destination: URL, style: AppButtonStyle = .primary) {
        self.title = title
        self.destination = destination
        self.style = style
    }
    
    var body: some View {
        Link(destination: destination) {
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
        AppLink("Google", destination: URL(string: "https://www.google.com")!)
        AppLink("Google", destination: URL(string: "https://www.google.com")!, style: .secondary)
    }
    .padding()
}
