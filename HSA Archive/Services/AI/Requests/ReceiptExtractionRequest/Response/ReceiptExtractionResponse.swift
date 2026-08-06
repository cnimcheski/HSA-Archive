//
//  ReceiptExtractionResponse.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import FirebaseAI

/// Converts a `Payload` instance into a more readable format.
enum ReceiptExtractionResponse: AIResponse, Decodable {
    case success(Payload.Fields)
    case noEligibleExpenses
    case unreadable
    case notReceipt
    
    /// Decodes a `ReceiptExtractionResponse` from a `Payload`.
    init(from decoder: Decoder) throws {
        let response = try Payload(from: decoder)
        self.init(from: response)
    }
    
    /// Creates a `ReceiptExtractionResponse` from a `Payload`.
    init(from response: Payload) {
        switch response.status {
        case .success:
            guard let fields = response.fields else {
                self = .unreadable
                return
            }
            self = .success(fields)
        case .noEligibleExpenses:
            self = .noEligibleExpenses
        case .unreadable:
            self = .unreadable
        case .notReceipt:
            self = .notReceipt
        }
    }
    
    static var schema: Schema {
        Payload.schema
    }
}
