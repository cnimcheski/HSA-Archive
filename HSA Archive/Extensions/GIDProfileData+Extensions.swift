//
//  GIDProfileData+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/14/26.
//

import GoogleSignIn

nonisolated extension GIDProfileData {
    /// Returns the user's first and last initials combined.
    var initials: String? {
        guard let givenInitial = self.givenName?.first,
              let familyInital = self.familyName?.first else { return nil }
        return String(givenInitial) + String(familyInital)
    }
}
