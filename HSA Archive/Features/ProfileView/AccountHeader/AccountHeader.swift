//
//  AccountHeader.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/14/26.
//

import GoogleSignIn
import SwiftUI

struct AccountHeader: View {
    private let profile: GIDProfileData?
    private let onSignIn: () -> Void
    
    init(profile: GIDProfileData?, onSignIn: @escaping () -> Void) {
        self.profile = profile
        self.onSignIn = onSignIn
    }
    
    var body: some View {
        content
            .listRowSeparator(.hidden)
    }
}

// MARK: - Private Views

private extension AccountHeader {
    @ViewBuilder
    var content: some View {
        if let profile {
            profileDetails(profile)
        } else {
            signInBanner
        }
    }
    
    func profileDetails(_ profile: GIDProfileData) -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            if let initials = profile.initials {
                profileInitials(initials)
            }
            profileIdentity(profile)
            googleAccountBadge
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func profileInitials(_ initials: String) -> some View {
        Text(initials)
            .font(.largeTitle)
            .foregroundStyle(.accent)
            .padding()
            .background(.regularMaterial, in: .circle)
    }
    
    func profileIdentity(_ profile: GIDProfileData) -> some View {
        VStack(spacing: .zero) {
            Text(profile.name)
                .font(.title3)
                .bold()
            Text(profile.email)
                .foregroundStyle(.secondary)
        }
    }
    
    var googleAccountBadge: some View {
        HStack(spacing: Theme.Spacing.small) {
            Image("google.logo")
                .resizable()
                .frame(width: 14, height: 14)
            Text("Signed in with Google")
                .font(.caption)
        }
        .padding(.vertical, Theme.Spacing.xSmall)
        .padding(.horizontal, Theme.Spacing.small)
        .background(.regularMaterial, in: .capsule)
    }
    
    var signInBanner: some View {
        VStack(spacing: Theme.Spacing.large) {
            signInPrompt
            AppButton("Sign in", action: onSignIn)
        }
        .padding(.horizontal)
    }
    
    var signInPrompt: some View {
        VStack(spacing: Theme.Spacing.large) {
            signInIcon
            signInMessage
        }
        .padding(.horizontal, Theme.Spacing.xxLarge)
        .multilineTextAlignment(.center)
    }
    
    var signInIcon: some View {
        Image(systemName: "person")
            .font(.largeTitle)
            .foregroundStyle(.accent)
            .padding()
            .background(.regularMaterial, in: .circle)
    }
    
    var signInMessage: some View {
        VStack(spacing: Theme.Spacing.small) {
            Text("You're not signed in")
                .font(.headline)
            Text("Sign in with Google to sync your profile, preferences, and account settings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview {
    AccountHeader(profile: nil) {
        // Do something when sign in button is tapped
    }
}
