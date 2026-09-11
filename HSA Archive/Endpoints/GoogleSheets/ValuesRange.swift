//
//  ValuesRange.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/8/26.
//

/// Represents a Google Sheets `ValuesRange` type.
/// Can be used as Body and Response for Endpoints.
nonisolated struct ValuesRange: Codable {
    let range: String?
    let majorDimension: String?
    let values: [[String]]?
    
    init(
        range: String? = nil,
        majorDimension: String? = nil,
        values: [[String]]? = nil
    ) {
        self.range = range
        self.majorDimension = majorDimension
        self.values = values
    }
    
    /// Encodes the type, discluding null values.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(range, forKey: .range)
        try container.encodeIfPresent(majorDimension, forKey: .majorDimension)
        try container.encodeIfPresent(values, forKey: .values)
    }
}
