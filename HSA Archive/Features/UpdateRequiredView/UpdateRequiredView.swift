//
//  UpdateRequiredView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/10/26.
//

import SwiftUI

struct UpdateRequiredView: View {
    var body: some View {
        ScrollView {
            content
                .padding()
                .containerRelativeFrame(.vertical)
        }
    }
}

// MARK: - Private Views

private extension UpdateRequiredView {
    var content: some View {
        VStack(spacing: Theme.Spacing.large) {
            updatePrompt
            updateExplanation
            if let appStoreURL = AppConstants.appStoreURL {
                updateLink(appStoreURL)
            }
            reassuranceMessage
        }
    }
    
    var updatePrompt: some View {
        ContentUnavailableView(
            "Update Required",
            systemImage: "exclamationmark.circle",
            description: Text("HSA Archive needs a newer version to open your archive safely.")
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    var updateExplanation: some View {
        AppGroupBox("Why am I seeing this?") {
            Text("Your archive was updated by a newer version of HSA Archive. Update the app to continue accessing your receipts in app.")
        }
    }
    
    func updateLink(_ appStoreURL: URL) -> some View {
        AppLink("Update HSA Archive", destination: appStoreURL)
    }
    
    var reassuranceMessage: some View {
        Text("Don't worry, you're saved receipts haven't been deleted.")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Previews

#Preview {
    UpdateRequiredView()
}
