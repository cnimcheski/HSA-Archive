//
//  DateFormatter+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import Foundation

extension DateFormatter {
    /// A shared `DateFormatter` for parsing and formatting ISO 8601 dates without a time component.
    static let iso8601DateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
