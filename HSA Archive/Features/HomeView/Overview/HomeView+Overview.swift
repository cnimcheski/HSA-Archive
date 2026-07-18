//
//  HomeView+Overview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension HomeView {
    struct Overview: View {
        var body: some View {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                totalPurchasesView
                balanceCards
                statusBarView
            }
            .defaultCardStyle()
        }
    }
}

// MARK: - Private Views

private extension HomeView.Overview {
    var totalPurchasesView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
            Text("Total receipts on file")
                .foregroundStyle(.secondary)
            Text(8420.15, format: AppFormatStyle.Currency.current)
                .xLargeTitle()
                .fontWeight(.bold)
        }
    }
    
    var balanceCards: some View {
        HStack {
            // TODO: - Add actual amounts here...
            BalanceCard(type: .reimbursed, amount: 2150)
            BalanceCard(type: .available, amount: 6270.15)
        }
    }
    
    var statusBarView: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: .accent, location: 0.3),
                        .init(color: .brandSecondary, location: 0.3)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 6)
    }
}

// MARK: - Previews

#Preview {
    HomeView.Overview()
}
