//
//  Placeholders.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/3/26.
//

import Foundation

/// Defines all the placeholders used within the App for redacted shimmer loading
enum Placeholders {
    
    // MARK: - Receipt Placeholders
    
    static var receipt: Receipt {
        .init(
            merchant: .placeholder(count: Int.random(in: 8...14)),
            description: .placeholder(count: Int.random(in: 10...18)),
            amount: 100.00,
            transactionDate: .now,
            category: .other,
            notes: .placeholder(count: Int.random(in: 12...18)),
            fileName: .placeholder(count: Int.random(in: 24...32))
        )
    }
}
