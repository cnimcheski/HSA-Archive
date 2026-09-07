//
//  Receipt+Filters.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/5/26.
//

import Foundation

nonisolated extension Receipt {
    struct Filters {
        var reimbursementStatus = ReimbursementStatus.all
        var categories = [Category]()
        var date = DateFilter()
        var sortingOption = SortingOption.dateNewest
        
        /// The number of active filter selections.
        var activeFilterCount: Int {
            categories.count
                + (reimbursementStatus != .all ? 1 : 0)
                + (date.range != .anyTime ? 1 : 0)
        }
    }
}

// MARK: - Matches Filters

nonisolated extension Receipt {
    /// Returns whether the receipt matches all provided filters.
    func matches(_ filters: Filters) -> Bool {
        (filters.categories.isEmpty || filters.categories.contains(category))
            && filters.reimbursementStatus.matches(isReimbursed: isReimbursed)
            && filters.date.dateInterval?.contains(transactionDate) ?? true
    }
}
