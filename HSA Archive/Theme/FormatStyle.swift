//
//  FormatStyle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/12/26.
//

import Foundation

enum AppFormatStyle {
    enum Currency {
        /// Gets the current `TextFormat` currency code based on the users settings.
        static var current: FloatingPointFormatStyle<Double>.Currency {
            .currency(code: Locale.current.currency?.identifier ?? "USD")
        }
    }
}
