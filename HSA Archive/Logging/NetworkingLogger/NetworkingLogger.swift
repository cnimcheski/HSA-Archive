//
//  NetworkingLogger.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/14/26.
//

import Networking

nonisolated struct NetworkingLogger: NetworkLogging {
    func log(_ message: @autoclosure () -> String) {
        Debug.log(message(), category: .network)
    }
}
