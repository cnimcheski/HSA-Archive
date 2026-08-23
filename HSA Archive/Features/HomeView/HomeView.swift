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
    }
}

// MARK: - Private Views

private extension HomeView {
    var content: some View {
        List {
            Overview()
            SyncAccountsView()
            RecentActivitySection()
        }
        .listStyle(.plain)
    }
    
    var uploadReceiptButton: some View {
        Button {
            viewModel.showUploadReceiptConfirmationDialog()
        } label: {
            Label("Scan a receipt", systemImage: "plus")
        }
        .confirmationDialog(viewModel: $viewModel.confirmationDialogViewModel)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HomeView(viewModel: .init())
    }
}
