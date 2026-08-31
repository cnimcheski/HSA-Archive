//
//  Container+Services.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/21/26.
//

import FactoryKit
import Networking

extension Container {
    var aiClient: Factory<AIClient> {
        self { FirebaseAIClient() }.singleton
    }
    
    @MainActor
    var appSession: Factory<AppSession> {
        self { AppSession() }.singleton
    }
    
    var googleAuthService: Factory<GoogleAuthService> {
        self { GoogleAuthService() }.singleton
    }

    var googleDriveService: Factory<GoogleDriveService> {
        self { GoogleDriveService() }.singleton
    }

    var googleSheetsService: Factory<GoogleSheetsService> {
        self { GoogleSheetsService() }.singleton
    }
    
    var googleNetworkingClient: Factory<NetworkingClient> {
        self {
            NetworkingClient(
                errorHandler: GoogleAPIErrorHandler(),
                logger: NetworkingLogger()
            )
        }.singleton
    }
    
    var receiptSpreadsheetService: Factory<ReceiptSpreadsheetService> {
        self { ReceiptSpreadsheetService() }.singleton
    }
    
    var remoteConfigClient: Factory<RemoteConfigClient> {
        self { RemoteConfigClient() }.singleton
    }
    
    var textRecognizer: Factory<TextRecognizer> {
        self { TextRecognizer() }
    }
}
