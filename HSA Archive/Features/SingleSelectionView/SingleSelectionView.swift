//
//  SingleSelectionView.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/1/25.
//

import SwiftUI

struct SingleSelectionView: View {
    @Bindable private var viewModel: ViewModel
    @FocusState private var isFocused: Bool
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: viewModel.searchPlaceholder
            )
            .searchFocused($isFocused)
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .onAppear { isFocused = true }
    }
}

// MARK: - Private Views

private extension SingleSelectionView {
    var content: some View {
        List(viewModel.filteredItems) { item in
            itemButton(item)
        }
        .listStyle(.plain)
        .overlay { overlayContent }
    }
    
    func itemButton(_ item: Selection) -> some View {
        Button {
            viewModel.selectItem(item)
        } label: {
            HStack {
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                }
                Text(item.title)
                if item == viewModel.initialSelection {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if viewModel.filteredItems.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        }
    }
}

// MARK: - Previews

#Preview {
    SingleSelectionView(
        viewModel: .init(
            navigationTitle: AppConstants.categoryPrompt,
            searchPlaceholder: AppConstants.categorySearchPlaceholder,
            items: Category.allCases.map(\.selection),
            initialSelection: Category.other.selection,
            onSelect: { selection in
                // Do something with selection
            }
        )
    )
}
