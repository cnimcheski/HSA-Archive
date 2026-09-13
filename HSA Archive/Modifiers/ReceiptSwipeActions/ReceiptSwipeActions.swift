//
//  ReceiptSwipeActions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/12/26.
//

import FactoryKit
import SwiftUI

extension View {
    /// Adds swipe actions for changing reimbursement status and deleting the receipt.
    func receiptSwipeActions(receipt: Receipt) -> some View {
        modifier(ReceiptSwipeActions(receipt: receipt))
    }
}

private struct ReceiptSwipeActions: ViewModifier {
    @Injected(\.receiptRepository) private var receiptRepository
    private let receipt: Receipt
    
    init(receipt: Receipt) {
        self.receipt = receipt
    }
    
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading) { reimbursementAction }
            .swipeActions(edge: .trailing) { deleteAction }
    }
}

// MARK: - Private Views

private extension ReceiptSwipeActions {
    var reimbursementAction: some View {
        Button(
            receipt.isReimbursed ? "Mark Available" : "Mark Reimbursed",
            systemImage: receipt.isReimbursed ? "arrow.uturn.backward" : "checkmark"
        ) {
            Task {
                await receiptRepository.toggleReimbursementStatus(for: receipt)
            }
        }
        .tint(receipt.isReimbursed ? .brandSecondary : .accent)
    }
    
    var deleteAction: some View {
        Button("Delete", systemImage: "trash") {
            Task {
                await receiptRepository.delete(receipt)
            }
        }
        .tint(.red)
    }
}
