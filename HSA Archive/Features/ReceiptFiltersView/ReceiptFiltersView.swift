//
//  ReceiptFiltersView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/3/26.
//

import Flow
import SwiftUI

struct ReceiptFiltersView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    closeButton
                }
            }
            .safeAreaInset(edge: .bottom) { safeAreaContent }
    }
}

// MARK: - Private Views

private extension ReceiptFiltersView {
    var content: some View {
        List {
            categoriesSection
        }
        .listStyle(.plain)
    }
    
    var categoriesSection: some View {
        Section {
            ListNavigationButton(action: viewModel.showCategoryMultiSelection) {
                if viewModel.filters.categories.isEmpty {
                    Text("None selected")
                } else {
                    HFlow {
                        ForEach(viewModel.filters.categories, id: \.self) { category in
                            categoryRow(category)
                        }
                    }
                }
            }
        } header: {
            Text("Categories")
        }
    }
    
    func categoryRow(_ category: Category) -> some View {
        Button {
            viewModel.removeCategory(category)
        } label: {
            HStack(spacing: Theme.Spacing.medium) {
                Image(systemName: category.systemImage)
                Text(category.rawValue)
                Image(systemName: "xmark")
            }
            .font(.caption)
            .padding(.vertical, 6)
            .padding(.horizontal, Theme.Spacing.small)
            .background(colorScheme == .dark ? .black : .gray.opacity(0.15))
            .clipShape(.rect(cornerRadius: Theme.CornerRadius.medium))
        }
        .tint(.primary)
    }
    
    var closeButton: some View {
        Button("Close", systemImage: "xmark", action: viewModel.close)
    }
    
    var safeAreaContent: some View {
        HStack {
            AppButton("Clear All", style: .secondary, action: viewModel.clearAll)
            AppButton("Apply", action: viewModel.apply)
        }
        .padding(.vertical, Theme.Spacing.small)
        .padding(.horizontal)
        .background(.background)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        ReceiptFiltersView(
            viewModel: .init(
                initialFilters: .init(
                    categories: [.dental, .doctorVisit]
                ),
                onApply: { filters in
                    // Do something with new filters
                }
            )
        )
    }
}
