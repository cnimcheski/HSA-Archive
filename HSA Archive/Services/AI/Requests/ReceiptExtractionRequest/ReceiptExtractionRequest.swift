//
//  ReceiptExtractionRequest.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import FirebaseAI

struct ReceiptExtractionRequest: AIRequest {
    typealias Response = ReceiptExtractionResponse
    
    let systemInstruction = "You extract structured HSA-eligible expense data from OCR text of medical receipts."
    let prompt: String
    
    init(text: String) {
        prompt = """
            Extract the fields defined by the response schema.

            Rules:
            - Use only information present in the OCR text.
            - Only extract HSA-eligible expenses.
            - Merchant: return the business or provider name.
            - Total: return the final amount paid by the customer, not a subtotal, balance, or insurance adjustment.
            - Date: use the purchase/payment date; return null if unknown.
            - Category: choose the best matching value from the response schema; use `other` if none clearly apply.
            - Return only valid structured output.

            OCR Text:
            \(text)
        """
    }
}
