//
//  Receipt.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/22/26.
//

import Foundation

nonisolated struct Receipt: Identifiable {
    let id: UUID
    var merchant: String
    var description: String
    var amount: Double
    var transactionDate: Date
    var category: Category
    var reimbursementDate: Date?
    var submissionDate: Date? = nil
    var notes: String
    var fileID: String?
    
    var isReimbursed: Bool {
        get { reimbursementDate != nil }
        set { reimbursementDate = newValue ? .now : nil }
    }
    
    var fileName: String {
        "\(transactionDate.formatted()) \(merchant) \(amount)"
    }
    
    /// Indicates whether the receipt has already been saved.
    var hasBeenSaved: Bool {
        fileID != nil
    }
    
    init(
        id: UUID = UUID(),
        merchant: String,
        description: String,
        amount: Double,
        transactionDate: Date,
        category: Category,
        reimbursementDate: Date? = nil,
        submissionDate: Date? = nil,
        notes: String,
        fileID: String?
    ) {
        self.id = id
        self.merchant = merchant
        self.description = description
        self.amount = amount
        self.transactionDate = transactionDate
        self.category = category
        self.reimbursementDate = reimbursementDate
        self.submissionDate = submissionDate
        self.notes = notes
        self.fileID = fileID
    }
}

// MARK: - ReceiptExtractionResponse Initializer

nonisolated extension Receipt {
    init(from fields: ReceiptExtractionResponse.Payload.Fields) {
        self.id = UUID()
        self.fileID = nil
        self.merchant = fields.merchant
        self.description = fields.description
        self.amount = fields.amount
        self.transactionDate = fields.transactionDate
        self.category = fields.category
        self.notes = ""
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
            fileID: nil
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
        fileID: String? = nil
    ) -> Self {
        .init(
            merchant: merchant,
            description: description,
            amount: amount,
            transactionDate: transactionDate,
            category: category,
            reimbursementDate: reimbursementDate,
            notes: notes,
            fileID: fileID
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
            || amount.formatted(AppFormatStyle.Currency.current).localizedStandardContains(searchText)
    }
}
