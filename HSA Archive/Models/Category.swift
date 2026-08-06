//
//  Category.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/23/26.
//

import FirebaseAI

enum Category: String, AIResponse, CaseIterable, Decodable {
    case other = "Other"
    case urgentCare = "Urgent Care"
    case surgery = "Surgery"
    
    var systemImage: String {
        switch self {
        case .other:
            "square.grid.2x2"
        case .urgentCare:
            "cross.case.fill"
        case .surgery:
            "stethoscope"
        }
    }
    
    static var schema: Schema {
        Schema.enumeration(
            values: rawValues,
            description: "The category that best matches the HSA-eligible expense. Use 'Other' if none apply."
        )
    }
}
