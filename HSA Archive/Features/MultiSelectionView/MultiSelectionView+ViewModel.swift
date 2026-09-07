//
//  MultiSelectionView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/3/26.
//

import Foundation
import Navigation

extension MultiSelectionView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension MultiSelectionView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case pop
        }
        
        let navigationTitle: String
        let searchPlaceholder: String
        private let items: [Selection]
        private let onDone: ([Selection]) -> Void
        
        weak var delegate: NavigationDelegate?
        
        var searchText: String = ""
        
        var filteredItems: [Selection] {
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedSearchText.isEmpty
                ? items
                : items.filter { $0.title.localizedStandardContains(trimmedSearchText) }
        }
        
        private(set) var selections: [Selection]
        
        init(
            navigationTitle: String,
            searchPlaceholder: String,
            items: [Selection],
            initialSelections: [Selection] = [],
            onDone: @escaping ([Selection]) -> Void
        ) {
            self.navigationTitle = navigationTitle
            self.searchPlaceholder = searchPlaceholder
            self.items = items
            self.selections = initialSelections
            self.onDone = onDone
        }
        
        func done() {
            onDone(selections)
            delegate?.navigate(to: .pop)
        }
        
        func clearAll() {
            onDone([])
            delegate?.navigate(to: .pop)
        }
        
        func toggle(_ item: Selection) {
            if selections.contains(item) {
                selections.removeAll { $0 == item }
            } else {
                selections.append(item)
            }
        }
        
        func isItemSelected(_ item: Selection) -> Bool {
            selections.contains(item)
        }
    }
}

