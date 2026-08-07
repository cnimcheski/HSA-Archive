//
//  Selection.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/6/26.
//

import Foundation

struct Selection: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String?

    init(title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }
}

// MARK: - Mock Selection

extension Selection {
    static let mock = Selection(title: "Dog", systemImage: "dog.fill")
}
