//
//  Receipt.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/22/26.
//

import Foundation

nonisolated struct Receipt: Identifiable {
    let id = UUID()
    var merchant: String
    var description: String
    var amount: Double
    var transactionDate: Date
    var category: Category
    var reimbursementDate: Date?
    var notes: String
    var fileName: String
    
    var isReimbursed: Bool {
        get { reimbursementDate != nil }
        set { reimbursementDate = newValue ? .now : nil }
    }
    
    init(
        merchant: String,
        description: String,
        amount: Double,
        transactionDate: Date,
        category: Category,
        reimbursementDate: Date? = nil,
        notes: String,
        fileName: String
    ) {
        self.merchant = merchant
        self.description = description
        self.amount = amount
        self.transactionDate = transactionDate
        self.category = category
        self.reimbursementDate = reimbursementDate
        self.notes = notes
        self.fileName = fileName
    }
}

// MARK: - ReceiptExtractionResponse Initializer

nonisolated extension Receipt {
    init(from fields: ReceiptExtractionResponse.Payload.Fields) {
        self.merchant = fields.merchant
        self.description = fields.description
        self.amount = fields.amount
        self.transactionDate = fields.transactionDate
        self.category = fields.category
        self.reimbursementDate = nil
        self.notes = ""
        self.fileName = "\(fields.transactionDate.formatted()) \(fields.merchant) \(fields.amount)"
    }
}

// MARK: - Empty Receipt

nonisolated extension Receipt {
    static var empty: Self {
        .init(
            merchant: "",
            description: "",
            amount: 0,
            transactionDate: .now,
            category: .other,
            notes: "",
            fileName: ""
        )
    }
}

// MARK: - Mock Receipt

nonisolated extension Receipt {
    static var mock: Self {
        .init(
            merchant: "Target",
            description: "Tampons",
            amount: 12.95,
            transactionDate: .now,
            category: .womensHealth,
            notes: "",
            fileName: ""
        )
    }
}
