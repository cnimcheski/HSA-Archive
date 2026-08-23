//
//  Container+Managers.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/15/26.
//

import FactoryKit
import Networking

extension Container {
    var googleDriveAPIManager: Factory<APIManager<GoogleAPIErrorHandler.APIGlobalError>> {
        self {
            APIManager(
                baseURL: AppConstants.googleDriveBaseURL,
                networkingClient: self.googleNetworkingClient(),
                errorHandler: self.googleAPIErrorHandler(),
                authenticator: self.googleAuthService(),
                logger: NetworkingLogger()
            )
        }.singleton
    }
    
    var googleSheetsAPIManager: Factory<APIManager<GoogleAPIErrorHandler.APIGlobalError>> {
        self {
            APIManager(
                baseURL: AppConstants.googleSheetsBaseURL,
                networkingClient: self.googleNetworkingClient(),
                errorHandler: self.googleAPIErrorHandler(),
                authenticator: self.googleAuthService(),
                logger: NetworkingLogger()
            )
        }.singleton
    }
    
    var userDefaultsManager: Factory<UserDefaultsManager> {
        self { UserDefaultsManager() }.singleton
    }
}
