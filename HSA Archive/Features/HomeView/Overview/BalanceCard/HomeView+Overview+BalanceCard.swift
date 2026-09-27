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
            AppGroupBox(padding: Theme.Spacing.medium) {
                amountView
            } label: {
                headerLabel
            }
        }
    }
}

// MARK: - Private Views

private extension HomeView.Overview.BalanceCard {
    var headerLabel: some View {
        Label {
            Text(type.rawValue.capitalized)
                .font(.subheadline)
                .bold()
        } icon: {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 8, height: 8)
                .foregroundStyle(type.fillColor)
        }
        .labelStyle(.customSpacing(Theme.Spacing.small))
    }
    
    var amountView: some View {
        Text(amount, format: AppFormatStyle.Currency.current)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
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
