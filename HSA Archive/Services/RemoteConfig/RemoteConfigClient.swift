//
//  RemoteConfigClient.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/26/26.
//

import FirebaseRemoteConfig

nonisolated final class RemoteConfigClient {
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    var modelName: String {
        remoteConfig.configValue(forKey: RemoteConfigKey.modelName.rawValue).stringValue
    }
    
    init() {
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 43200 // 12 hours
        #endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func fetchAndActivate() async {
        _ = try? await remoteConfig.fetchAndActivate()
    }
}
