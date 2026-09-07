//
//  Receipt+Filters.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/5/26.
//

nonisolated extension Receipt {
    struct Filters {
        var categories = [Category]()
        var reimbursementStatus = ReimbursementStatus.all
        
        /// The number of active filter selections.
        var activeFilterCount: Int {
            categories.count
                + (reimbursementStatus != .all ? 1 : 0)
        }
    }
}

// MARK: - Reimbursement Status

nonisolated extension Receipt.Filters {
    enum ReimbursementStatus: CaseIterable {
        case all
        case available
        case reimbursed
        
        var title: String {
            switch self {
            case .all:
                "All"
            case .available:
                "Available"
            case .reimbursed:
                "Reimbursed"
            }
        }
        
        /// Returns whether the status matches the receipt's reimbursement state.
        func matches(isReimbursed: Bool) -> Bool {
            switch self {
            case .all:
                true
            case .available:
                !isReimbursed
            case .reimbursed:
                isReimbursed
            }
        }
    }
}

// MARK: - Matches Filters

nonisolated extension Receipt {
    /// Returns whether the receipt matches all provided filters.
    func matches(_ filters: Filters) -> Bool {
        (filters.categories.isEmpty || filters.categories.contains(category))
            && filters.reimbursementStatus.matches(isReimbursed: isReimbursed)
    }
}
