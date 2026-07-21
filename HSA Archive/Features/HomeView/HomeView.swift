//
//  HomeView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import Dialogs
import SwiftUI

struct HomeView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle("HSA Archive")
            .toolbar { uploadReceiptButton }
            .alert(viewModel: $viewModel.alertViewModel)
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
            viewModel.showReceiptScanner()
        } label: {
            Label("Scan a receipt", systemImage: "plus")
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
