//
//  Data+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/22/26.
//

import Foundation

nonisolated extension Data {
    /// Appends the UTF-8 representation of a string.
    mutating func append(_ string: String) {
        append(Data(string.utf8))
    }
}
