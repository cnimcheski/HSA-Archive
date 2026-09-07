//
//  ErrorBanner.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/29/26.
//

import SwiftUI

struct ErrorBanner: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.medium) {
            leadingImage
            errorText
            Spacer()
            trailingButtons
        }
        .defaultCardStyle(backgroundColor: .red.withBackgroundOpacity)
        .buttonStyle(.plain)
    }
}

// MARK: - Private Views

private extension ErrorBanner {
    var leadingImage: some View {
        Image(systemName: "exclamationmark.triangle")
            .font(.title3)
            .foregroundStyle(.red)
            .padding(Theme.Spacing.small)
            .background(.background)
            .clipShape(.circle)
    }
    
    var errorText: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
            Text(viewModel.title)
                .font(.headline)
            Text(viewModel.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var trailingButtons: some View {
        VStack(alignment: .trailing, spacing: Theme.Spacing.xSmall) {
            closeButton
            Spacer()
            if let action = viewModel.action {
                actionButton(action)
            }
        }
    }
    
    var closeButton: some View {
        Button("Close", systemImage: "xmark", action: viewModel.onClose)
            .tint(.primary)
            .labelStyle(.iconOnly)
    }
    
    func actionButton(_ action: Action) -> some View {
        Button {
            action.handler()
        } label: {
            Text(action.title)
                .foregroundStyle(.red)
                .padding(.vertical, Theme.Spacing.xSmall)
                .padding(.horizontal, Theme.Spacing.small)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.large))
        }
    }
}

// MARK: - Previews

#Preview {
    ScrollView {
        ErrorBanner(
            viewModel: .general(
                onClose: {
                    // Handle close action
                }, onRetry: {
                    // Handle retry action
                }
            )
        )
        .padding()
    }
}
