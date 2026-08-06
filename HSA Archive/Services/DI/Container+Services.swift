//
//  Container+Services.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/21/26.
//

import FactoryKit

extension Container {
    var aiClient: Factory<AIClient> {
        self { FirebaseAIClient() }.singleton
    }
    
    var textRecognizer: Factory<TextRecognizer> {
        self { TextRecognizer() }
    }
    
    var remoteConfigClient: Factory<RemoteConfigClient> {
        self { RemoteConfigClient() }.singleton
    }
}
