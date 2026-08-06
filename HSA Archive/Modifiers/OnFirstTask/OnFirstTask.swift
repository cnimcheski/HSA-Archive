//
//  OnFirstTask.swift
//  climbto350
//
//  Created by Steve Nimcheski on 10/17/25.
//

import SwiftUI

extension View {
    /// Runs the given async task action on the first appearance of a view.
    func onFirstTask(_ action: @escaping () async -> Void) -> some View {
        modifier(OnFirstTask(action: action))
    }
}

struct OnFirstTask: ViewModifier {
    @State private var hasAppeared = false
    private let action: () async -> Void
    
    init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .task(task)
    }
}

// MARK: - Private Methods

private extension OnFirstTask {
    func task() async {
        guard !hasAppeared else { return }
        hasAppeared = true
        await action()
    }
}
