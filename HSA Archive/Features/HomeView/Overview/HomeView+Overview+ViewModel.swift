//
//  HomeView+Overview+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/26/26.
//

import Foundation

extension HomeView.Overview {
    final class ViewModel {
        let isLoading: Bool
        private let receipts: [Receipt]
        
        var totalAmount: Double {
            receipts.map { $0.amount }.reduce(0, +)
        }
        
        var reimbursedAmount: Double {
            receipts.filter { $0.isReimbursed }.map { $0.amount }.reduce(0, +)
        }
        
        var availableAmount: Double {
            receipts.filter { !$0.isReimbursed }.map { $0.amount }.reduce(0, +)
        }
        
        var statusLocation: CGFloat {
            reimbursedAmount / totalAmount
        }
        
        init(receipts: [Receipt], isLoading: Bool) {
            self.receipts = receipts
            self.isLoading = isLoading
        }
    }
}
