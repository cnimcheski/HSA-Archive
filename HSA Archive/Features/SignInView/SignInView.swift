//
//  SignInView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

import GoogleSignInSwift
import SwiftUI

struct SignInView: View {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        // Using a NavigationStack so the close button can be presented as a toolbar item
        NavigationStack {
            ScrollView {
                content
            }
            .toolbar { closeButton }
        }
    }
}

// MARK: - Private Views

private extension SignInView {
    var content: some View {
        VStack(spacing: 60) {
            introductionView
            BenefitsView()
            signInSection
        }
        .padding()
        .containerRelativeFrame(.vertical)
    }
    
    var introductionView: some View {
        VStack(spacing: Theme.Spacing.xLarge) {
            logoImage
            introductionText
        }
    }
    
    var logoImage: some View {
        Image(.logo)
            .resizable()
            .frame(width: 65, height: 65)
            .defaultCardStyle(padding: Theme.Spacing.xSmall)
    }
    
    var introductionText: some View {
        VStack(spacing: Theme.Spacing.medium) {
            Text("Sign in to HSA Archive")
                .font(.title.bold())
            Text("Here's what signing in with Google gives you.")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var signInSection: some View {
        VStack(spacing: Theme.Spacing.large) {
            googleSignInButton
            signInRequirementView
            legalDisclaimerView
        }
    }
    
    var googleSignInButton: some View {
        GoogleSignInButton(style: .wide) {
            Task {
                await viewModel.signIn()
            }
        }
        .disabled(viewModel.isSigningIn)
    }
    
    var signInRequirementView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("Signing in is required to save receipt data")
        }
        .foregroundStyle(.brandSecondary)
    }
    
    var legalDisclaimerView: some View {
        // TODO: - Add links to terms of service and privacy policy
        Text("By continuing, you agree to HSA Archive's Terms of Service and Privacy Policy.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
    
    var closeButton: some View {
        Button(action: viewModel.close) {
            Label("Close", systemImage: "xmark")
        }
        .disabled(viewModel.isSigningIn)
    }
}

// MARK: - Previews

#Preview {
    SignInView(
        viewModel: .init(
            onSuccess: {
                // Run some code upon successfully signing in
            }
        )
    )
}
