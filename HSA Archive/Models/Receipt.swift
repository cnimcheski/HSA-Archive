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
    var submissionDate: Date? = nil
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
        submissionDate: Date? = nil,
        notes: String,
        fileName: String
    ) {
        self.merchant = merchant
        self.description = description
        self.amount = amount
        self.transactionDate = transactionDate
        self.category = category
        self.reimbursementDate = reimbursementDate
        self.submissionDate = submissionDate
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
    /// Returns a fully customizable mock Receipt.
    static func mock(
        merchant: String = "Target",
        description: String = "Tampons",
        amount: Double = 12.95,
        transactionDate: Date = .now,
        category: Category = .womensHealth,
        reimbursementDate: Date? = nil,
        notes: String = "",
        fileName: String = ""
    ) -> Self {
        .init(
            merchant: merchant,
            description: description,
            amount: amount,
            transactionDate: transactionDate,
            category: category,
            reimbursementDate: reimbursementDate,
            notes: notes,
            fileName: fileName
        )
    }
}

// MARK: - Matches Search Text

nonisolated extension Receipt {
    /// Returns whether the receipt matches the given search text.
    func matches(searchText: String) -> Bool {
        searchText.isEmpty
            || merchant.localizedStandardContains(searchText)
            || description.localizedStandardContains(searchText)
    }
}
