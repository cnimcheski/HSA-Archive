//
//  ReceiptExtractionResponse+Payload+Status.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/27/26.
//

import FirebaseAI

extension ReceiptExtractionResponse.Payload {
    enum Status: String, AIResponse, CaseIterable, Decodable {
        case success
        case noEligibleExpenses
        case unreadable
        case notReceipt
        
        static var schema: Schema {
            Schema.enumeration(
                values: rawValues,
                description: "The outcome of analyzing the receipt text."
            )
        }
    }
}
