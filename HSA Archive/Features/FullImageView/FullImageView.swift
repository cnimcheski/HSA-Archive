//
//  FullImageView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import SwiftUI

struct FullImageView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // Using a NavigationStack so the close button can be presented as a toolbar item
        NavigationStack {
            Image(uiImage: viewModel.uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        closeButton
                    }
                }
        }
    }
}

// MARK: - Private Views

private extension FullImageView {
    var closeButton: some View {
        Button("Close", systemImage: "xmark", action: viewModel.close)
    }
}

// MARK: - Previews

#Preview {
    FullImageView(viewModel: .init(uiImage: .init(systemName: "dog")!))
}
