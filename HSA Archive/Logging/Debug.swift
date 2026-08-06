//
//  Debug.swift
//  climbto350
//
//  Created by Steve Nimcheski on 10/10/25.
//

import Foundation
import os

/// Used to print debug messages to console
nonisolated struct Debug {
    static func log(_ message: String, category: LogCategory) {
        #if DEBUG
        let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "me.nimcheski.chris.climbto350",
            category: category.rawValue
        )
        logger.debug("[DEBUG] \(message)\n")
        #endif
    }
}
