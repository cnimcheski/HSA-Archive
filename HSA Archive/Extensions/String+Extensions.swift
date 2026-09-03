//
//  String+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/3/26.
//

/// Used to create an arbitrary String with the given count.
/// Especially useful when creating placeholder String's for redacted shimmer loaders.
nonisolated extension String {
    static func placeholder(count: Int) -> String {
        .init(repeating: "x", count: count)
    }
}
