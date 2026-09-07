//
//  ReceiptFiltersView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/3/26.
//

import Navigation
import SwiftUI

extension ReceiptFiltersView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension ReceiptFiltersView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case categoriesSelection(MultiSelectionView.ViewModel)
            case dismiss
        }
        
        private let onApply: (Receipt.Filters) -> Void
        
        weak var delegate: NavigationDelegate?
        
        var reimbursementStatus: Binding<Receipt.Filters.ReimbursementStatus> {
            .init(
                get: { self.filters.reimbursementStatus },
                set: { self.filters.reimbursementStatus = $0 }
            )
        }
        
        private(set) var filters: Receipt.Filters
        
        init(initialFilters: Receipt.Filters, onApply: @escaping (Receipt.Filters) -> Void) {
            self.onApply = onApply
            filters = initialFilters
        }
        
        func clearAll() {
            onApply(.init())
            delegate?.navigate(to: .dismiss)
        }
        
        func apply() {
            onApply(filters)
            delegate?.navigate(to: .dismiss)
        }
        
        func showCategoryMultiSelection() {
            delegate?.navigate(
                to: .categoriesSelection(
                    .init(
                        navigationTitle: AppConstants.categoriesPrompt,
                        searchPlaceholder: AppConstants.categorySearchPlaceholder,
                        items: Category.allCases.map(\.selection),
                        initialSelections: filters.categories.map(\.selection),
                        onDone: updateCategories
                    )
                )
            )
        }
        
        func removeCategory(_ category: Category) {
            filters.categories.removeAll { $0 == category }
        }
        
        func updateSortingOption(_ sortingOption: Receipt.Filters.SortingOption) {
            filters.sortingOption = sortingOption
        }
        
        func close() {
            delegate?.navigate(to: .dismiss)
        }
    }
}

// MARK: - Private Methods

private extension ReceiptFiltersView.ViewModel {
    func updateCategories(_ selections: [Selection]) {
        filters.categories = selections.compactMap { .init(rawValue: $0.title) }
    }
}
