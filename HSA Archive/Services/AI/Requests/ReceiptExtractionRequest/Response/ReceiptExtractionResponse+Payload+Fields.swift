//
//  ReceiptExtractionResponse+Payload+Fields.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/27/26.
//

import FirebaseAI
import Foundation

extension ReceiptExtractionResponse.Payload {
    struct Fields: AIResponse, Decodable {
        let merchant: String
        let description: String
        let amount: Double
        let transactionDate: Date
        let category: Category
        
        static var schema: Schema {
            Schema.object(
                properties: [
                    "merchant": Schema.string(description: "The merchant/vendor business name. Use a short recognizable name."),
                    "description": Schema.string(description: "A very brief description of the HSA-eligible purchase or service."),
                    "amount": Schema.double(description: "The total amount of all HSA-eligible items found, including applicable tax."),
                    "transactionDate": Schema.string(description: "The transaction date from the receipt text in yyyy-MM-dd format."),
                    "category": Category.schema
                ],
                description: "The extracted details of the HSA-eligible transaction."
            )
        }
    }
}
