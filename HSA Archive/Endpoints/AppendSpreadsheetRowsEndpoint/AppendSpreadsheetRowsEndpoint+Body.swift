//
//  AppendSpreadsheetRowsBody.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/13/26.
//

nonisolated extension AppendSpreadsheetRowsEndpoint {
    struct Body: Encodable {
        let values: [[String]]
    }
}
