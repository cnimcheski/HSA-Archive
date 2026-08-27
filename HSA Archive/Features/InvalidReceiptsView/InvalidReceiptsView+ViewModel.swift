//
//  InvalidReceiptsView+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/25/26.
//

import Navigation

extension InvalidReceiptsView {
    final class ViewModel: NavigationModel {
        let failedRows: [ReceiptSpreadsheetDecoder.Response.FailedRow]
        
        init(failedRows: [ReceiptSpreadsheetDecoder.Response.FailedRow]) {
            self.failedRows = failedRows
        }
    }
}
