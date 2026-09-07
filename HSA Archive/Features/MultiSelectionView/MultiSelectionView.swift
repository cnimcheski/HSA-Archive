//
//  MultiSelectionView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/3/26.
//

import SwiftUI

struct MultiSelectionView: View {
    @Bindable private var viewModel: ViewModel
    
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
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .safeAreaInset(edge: .bottom) { safeAreaContent }
    }
}

// MARK: - Private Views

private extension MultiSelectionView {
    var content: some View {
        List(viewModel.filteredItems) { item in
            itemButton(item)
        }
        .listStyle(.plain)
        .overlay { overlayContent }
    }
    
    func itemButton(_ item: Selection) -> some View {
        let isSelected = viewModel.isItemSelected(item)
        return Button {
            viewModel.toggle(item)
        } label: {
            HStack {
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                }
                Text(item.title)
                Spacer()
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .accent : .secondary)
            }
        }
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if viewModel.filteredItems.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        }
    }
    
    var safeAreaContent: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            selectionCountText
            actionButtons
        }
        .padding(.vertical, Theme.Spacing.small)
        .padding(.horizontal)
        .background(.background)
    }
    
    var selectionCountText: some View {
        Text("\(viewModel.selections.count) selected")
            .padding(.horizontal, Theme.Spacing.small)
    }
    
    var actionButtons: some View {
        HStack {
            AppButton("Clear All", style: .secondary, action: viewModel.clearAll)
            AppButton("Done", action: viewModel.done)
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        MultiSelectionView(
            viewModel: .init(
                navigationTitle: AppConstants.categoriesPrompt,
                searchPlaceholder: AppConstants.categorySearchPlaceholder,
                items: Category.allCases.map(\.selection),
                onDone: { selections in
                    // Do something with selections
                }
            )
        )
    }
}
