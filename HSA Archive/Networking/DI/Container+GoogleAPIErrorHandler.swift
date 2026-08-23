//
//  Container+GoogleAPIErrorHandler.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

import FactoryKit

extension Container {
    var googleAPIErrorHandler: Factory<GoogleAPIErrorHandler> {
        self { GoogleAPIErrorHandler() }
    }
}
