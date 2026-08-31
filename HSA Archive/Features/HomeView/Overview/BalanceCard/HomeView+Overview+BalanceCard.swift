//
//  HomeView+Overview+BalanceCard.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/12/26.
//

import SwiftUI

extension HomeView.Overview {
    struct BalanceCard: View {
        enum CardType: String {
            case reimbursed
            case available
            
            var fillColor: Color {
                switch self {
                case .reimbursed:
                    .accent
                case .available:
                    .brandSecondary
                }
            }
        }
        
        private let type: CardType
        private let amount: Double
        private let isLoading: Bool
        
        init(type: CardType, amount: Double, isLoading: Bool) {
            self.type = type
            self.amount = amount
            self.isLoading = isLoading
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Theme.Spacing.xSmall) {
                headerView(type: type)
                amountView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .defaultCardStyle(
                backgroundColor: .accentBackground,
                padding: Theme.Spacing.medium
            )
        }
    }
}

// MARK: - Private Views

private extension HomeView.Overview.BalanceCard {
    func headerView(type: CardType) -> some View {
        HStack {
            Circle()
                .fill(type.fillColor)
                .frame(width: 8)
            Text(type.rawValue.capitalized)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var amountView: some View {
        Text(amount, format: AppFormatStyle.Currency.current)
            .font(.headline)
            .redactedShimmer(isShimmering: isLoading)
    }
}

// MARK: - Previews

#Preview {
    VStack {
        HStack {
            HomeView.Overview.BalanceCard(type: .reimbursed, amount: 1046.57, isLoading: false)
            HomeView.Overview.BalanceCard(type: .available, amount: 2112.34, isLoading: false)
        }
        HStack {
            HomeView.Overview.BalanceCard(type: .reimbursed, amount: 1046.57, isLoading: true)
            HomeView.Overview.BalanceCard(type: .available, amount: 2112.34, isLoading: true)
        }
    }
    .padding()
}
