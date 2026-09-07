//
//  Receipt+Filters.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/5/26.
//

nonisolated extension Receipt {
    struct Filters {
        var categories = [Category]()
        
        /// The number of active filter selections.
        var activeFilterCount: Int {
            categories.count
        }
    }
}

// MARK: - Matches Filters

nonisolated extension Receipt {
    /// Returns whether the receipt matches all provided filters.
    func matches(_ filters: Filters) -> Bool {
        filters.categories.isEmpty || filters.categories.contains(category)
    }
}
