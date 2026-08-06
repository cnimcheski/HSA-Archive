//
//  AIResponse.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import FirebaseAI

protocol AIResponse {
    /// The schema describing the expected AI generated response for this conforming type.
    static var schema: Schema { get }
}
