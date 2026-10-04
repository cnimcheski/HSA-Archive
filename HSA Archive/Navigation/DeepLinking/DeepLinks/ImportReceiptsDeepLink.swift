//
//  ImportReceiptsDeepLink.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/30/26.
//

import Navigation

/// hsaarchive://home/import-receipts?batch=<batch>
nonisolated struct ImportReceiptsDeepLink: DeepLink {
    static let template: DeepLinkTemplate = .init()
        .term("home")
        .term("import-receipts")
        .queryStringParameters([.requiredString(named: "batch")])
    
    let batch: String

    init(values: DeepLinkValues) {
        batch = values.query["batch"] as! String
    }
}
