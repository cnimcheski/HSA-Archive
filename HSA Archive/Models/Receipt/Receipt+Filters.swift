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

// MARK: - Date Range

nonisolated extension Receipt.Filters {
    struct DateFilter {
        enum Range: CaseIterable {
            case anyTime
            case thisMonth
            case lastThreeMonths
            case thisYear
            case custom
            
            var title: String {
                switch self {
                case .anyTime:
                    "Any time"
                case .thisMonth:
                    "This month"
                case .lastThreeMonths:
                    "Last 3 months"
                case .thisYear:
                    "This year"
                case .custom:
                    "Custom range..."
                }
            }
        }
        
        var range = Range.anyTime
        var customStartDate = Calendar.current.dateInterval(of: .year, for: .now)?.start ?? .now
        var customEndDate = Date.now
        
        var dateInterval: DateInterval? {
            let calendar = Calendar.current
            let now = Date.now

            switch range {
            case .anyTime:
                return nil
            case .thisMonth:
                return calendar.dateInterval(of: .month, for: now)
            case .lastThreeMonths:
                guard let currentMonth = calendar.dateInterval(of: .month, for: now),
                      let start = calendar.date(byAdding: .month, value: -2, to: currentMonth.start)
                else { return nil }
                return DateInterval(start: start, end: currentMonth.end)
            case .thisYear:
                return calendar.dateInterval(of: .year, for: now)
            case .custom:
                let start = calendar.startOfDay(for: customStartDate)
                guard let end = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: calendar.startOfDay(for: customEndDate)
                ) else { return nil }
                return DateInterval(start: start, end: end)
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
            && filters.date.dateInterval?.contains(transactionDate) ?? true
    }
}
