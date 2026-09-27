//
//  ListLoadingRow.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/23/26.
//

import SwiftUI

struct ListLoadingRow<Content: View>: View {
    private let role: ButtonRole?
    private let isLoading: Bool
    private let action: () -> Void
    private let content: Content
    
    init(
        role: ButtonRole? = nil,
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.role = role
        self.isLoading = isLoading
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(role: role, action: action) {
            HStack {
                content
                Spacer()
                if isLoading {
                    ProgressView()
                }
            }
        }
        .disabled(isLoading)
    }
}

// MARK: - Title overload init

extension ListLoadingRow where Content == Text {
    init(
        title: String,
        loadingTitle: String,
        role: ButtonRole? = nil,
        isLoading: Bool,
        action: @escaping () -> Void
    ) {
        self.init(role: role, isLoading: isLoading, action: action) {
            Text(isLoading ? loadingTitle : title)
        }
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var isDeletingAccount = false
    List {
        ListLoadingRow(
            title: "Delete account",
            loadingTitle: "Deleting account...",
            isLoading: isDeletingAccount
        ) {
            isDeletingAccount = true
        }
    }
    .listStyle(.plain)
}
