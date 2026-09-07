//
//  Selection.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/6/26.
//

import Foundation

nonisolated struct Selection: Identifiable, Hashable {
    let title: String
    let systemImage: String?
    var id: Self { self }

    init(title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }
}

// MARK: - Mock Selection

nonisolated extension Selection {
    static let mock = Selection(title: "Dog", systemImage: "dog.fill")
}
