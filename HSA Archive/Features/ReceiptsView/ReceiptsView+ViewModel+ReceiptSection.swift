//
//  ReceiptsView+ViewModel+ReceiptSection.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/1/26.
//

import Foundation

extension ReceiptsView.ViewModel {
    /// A section of receipts grouped by their transaction date.
    struct ReceiptSection: Identifiable {
        let date: Date
        let receipts: [Receipt]
        
        var id: Date { date }
        var title: String { date.formatted(.dateTime.month(.wide).year()) }
    }
}
