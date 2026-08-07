//
//  SelectionView+ViewModel.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/1/25.
//

import Navigation
import SwiftUI

extension SelectionView {
    protocol NavigationDelegate: AnyObject {
        @MainActor func navigate(to destination: ViewModel.Destination)
    }
}

extension SelectionView {
    @Observable
    final class ViewModel: NavigationModel, Navigating {
        enum Destination {
            case pop
        }
        
        let navigationTitle: String
        let searchPlaceholder: String
        private let items: [Selection]
        private let onSelect: (Selection) -> Void
        
        weak var delegate: NavigationDelegate?
        
        var searchText: String = ""
        
        var filteredItems: [Selection] {
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedSearchText.isEmpty
                ? items
                : items.filter { $0.title.localizedStandardContains(trimmedSearchText) }
        }
        
        private(set) var selection: String
        
        init(
            navigationTitle: String,
            searchPlaceholder: String,
            items: [Selection],
            initialSelection: String = "",
            onSelect: @escaping (Selection) -> Void
        ) {
            self.navigationTitle = navigationTitle
            self.searchPlaceholder = searchPlaceholder
            self.items = items
            self.selection = initialSelection
            self.onSelect = onSelect
        }
        
        func selectItem(_ item: Selection) {
            onSelect(item)
            delegate?.navigate(to: .pop)
        }
    }
}
