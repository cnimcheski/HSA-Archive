//
//  Container+Repositories.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/15/26.
//

import FactoryKit

extension Container {
    @MainActor
    var receiptRepository: Factory<ReceiptRepository> {
        self { ReceiptRepository() }.singleton
    }
}
