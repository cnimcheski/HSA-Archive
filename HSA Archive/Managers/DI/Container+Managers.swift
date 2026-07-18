//
//  Container+Managers.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/15/26.
//

import FactoryKit

extension Container {
    @MainActor
    var userDefaultsManager: Factory<UserDefaultsManager> {
        self { UserDefaultsManager() }.singleton
    }
}
