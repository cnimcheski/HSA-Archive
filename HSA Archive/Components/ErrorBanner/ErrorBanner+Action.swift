//
//  ErrorBanner+Action.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/31/26.
//

extension ErrorBanner {
    /// Defines an Action for the ErrorBanner.
    struct Action {
        let title: String
        let handler: () -> Void
        
        /// Private initializer so that instances can only be created from the Factory Initializers.
        private init(title: String, handler: @escaping () -> Void) {
            self.title = title
            self.handler = handler
        }
    }
}

// MARK: - Factory Initializers

extension ErrorBanner.Action {
    static func retry(_ handler: @escaping () -> Void) -> Self {
        .init(
            title: "Retry",
            handler: handler
        )
    }
}
