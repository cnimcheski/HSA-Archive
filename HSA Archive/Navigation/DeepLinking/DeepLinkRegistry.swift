//
//  DeepLinkRegistry.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/30/26.
//

import Navigation

nonisolated struct DeepLinkRegistry: DeepLinkRegistering {
    static var deepLinkTypes: [any DeepLink.Type] = [
        ImportReceiptsDeepLink.self
    ]
}
