//
//  Receipt+Filters+SortingOption.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

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
