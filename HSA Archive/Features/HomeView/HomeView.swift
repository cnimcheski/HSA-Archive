//
//  HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import SwiftUI

struct HomeView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle("HSA Archive")
            .toolbar { uploadReceiptButton }
    }
}

// MARK: - Private Views

private extension HomeView {
    var content: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.xLarge) {
                Overview()
                SyncAccountsView()
                RecentActivitySection()
            }
            .padding()
        }
    }
    
    var uploadReceiptButton: some View {
        Button {
            // TODO: - Fill in later...
        } label: {
            Label("Upload a receipt", systemImage: "plus")
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
