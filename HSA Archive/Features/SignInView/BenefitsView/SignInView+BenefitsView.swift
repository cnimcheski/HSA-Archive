//
//  SignInView+BenefitsView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/12/26.
//

import SwiftUI

extension SignInView {
    struct BenefitsView: View {
        var body: some View {
            HStack {
                ForEach(Benefit.allCases, id: \.self) { benefit in
                    benefitView(benefit)
                }
            }
        }
    }
}

// MARK: - Private Views

private extension SignInView.BenefitsView {
    func benefitView(_ benefit: Benefit) -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            iconView(benefit)
            descriptionView(benefit)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
    
    func iconView(_ benefit: Benefit) -> some View {
        Image(systemName: benefit.systemImage)
            .font(.headline)
            .defaultCardStyle(backgroundColor: .accentBackground)
    }
    
    func descriptionView(_ benefit: Benefit) -> some View {
        VStack {
            Text(benefit.title)
                .font(.headline)
            Text(benefit.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Previews

#Preview {
    SignInView.BenefitsView()
        .padding()
}
