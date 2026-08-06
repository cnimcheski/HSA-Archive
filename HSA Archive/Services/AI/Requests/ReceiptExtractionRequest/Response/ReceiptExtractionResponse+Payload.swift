//
//  ReceiptExtractionResponse+Payload.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/29/26.
//

import FirebaseAI

extension ReceiptExtractionResponse {
    struct Payload: AIResponse, Decodable {
        let status: Status
        let fields: Fields?
        
        static var schema: Schema {
            Schema.object(
                properties: [
                    "status": Status.schema,
                    "fields": Fields.schema
                ],
                optionalProperties: ["fields"],
                description: "The result of analyzing the receipt text."
            )
        }
    }
}
