//
//  Receipt+Filters+ReimbursementStatus.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/7/26.
//

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
