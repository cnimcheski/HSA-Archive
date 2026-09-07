//
//  ListNavigationButton.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/21/25.
//

import SwiftUI

enum ListNavigationButtonType {
    case link
    case dropDown
    
    var imageString: String {
        switch self {
        case .link:
            "chevron.right"
        case .dropDown:
            "chevron.down"
        }
    }
}

struct ListNavigationButton<Content: View>: View {
    let content: Content
    let type: ListNavigationButtonType
    let action: () -> Void
    
    init(
        action: @escaping () -> Void,
        type: ListNavigationButtonType = .link,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.type = type
        self.content = content()
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                content
                Spacer()
                Image(systemName: type.imageString)
                    .foregroundStyle(.gray.opacity(0.5))
                    .fontWeight(.semibold)
                    .imageScale(.small)
            }
        }
    }
}

// MARK: - Title overload init

extension ListNavigationButton where Content == Text {
    init(
        _ title: String,
        type: ListNavigationButtonType = .link,
        action: @escaping () -> Void
    ) {
        self.init(action: action, type: type) {
            Text(title)
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        ListNavigationButton("Title", action: {})
    }
}
