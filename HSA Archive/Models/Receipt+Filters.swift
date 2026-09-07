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
        var sortingOption = SortingOption.dateNewest
        
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

// MARK: - Sorting Options

nonisolated extension Receipt.Filters {
    enum SortingOption: CaseIterable {
        case dateNewest
        case dateOldest
        case amountHighest
        case amountLowest
        
        var title: String {
            switch self {
            case .dateNewest:
                "Newest"
            case .dateOldest:
                "Oldest"
            case .amountHighest:
                "Highest Amount"
            case .amountLowest:
                "Lowest Amount"
            }
        }
        
        /// Indicates whether receipts should be grouped into monthly sections or flattened.
        var groupsByMonth: Bool {
            switch self {
            case .dateNewest, .dateOldest:
                true
            case .amountHighest, .amountLowest:
                false
            }
        }
        
        /// Returns whether two receipts are in the correct order for this sorting option.
        func areInOrder(_ lhs: Receipt, _ rhs: Receipt) -> Bool {
            switch self {
            case .dateNewest:
                lhs.transactionDate > rhs.transactionDate
            case .dateOldest:
                lhs.transactionDate < rhs.transactionDate
            case .amountHighest:
                lhs.amount > rhs.amount
            case .amountLowest:
                lhs.amount < rhs.amount
            }
        }
        
        /// Returns whether two receipt sections are in the correct order for this sorting option.
        func areSectionsInOrder(
            _ lhs: ReceiptsView.ViewModel.ReceiptSection,
            _ rhs: ReceiptsView.ViewModel.ReceiptSection
        ) -> Bool {
            switch self {
            case .dateNewest:
                lhs.date > rhs.date
            case .dateOldest:
                lhs.date < rhs.date
            case .amountHighest, .amountLowest:
                false
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
