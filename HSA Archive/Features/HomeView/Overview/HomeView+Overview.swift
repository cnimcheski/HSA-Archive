//
//  HomeView+Overview.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/11/26.
//

import SwiftUI

extension HomeView {
    struct Overview: View {
        private let viewModel: ViewModel
        
        init(receipts: [Receipt], isLoading: Bool) {
            viewModel = .init(receipts: receipts, isLoading: isLoading)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                totalPurchasesView
                balanceCards
                statusBarView
            }
            .defaultCardStyle()
            .listRowSeparator(.hidden)
        }
    }
}

// MARK: - Private Views

private extension HomeView.Overview {
    var totalPurchasesView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxSmall) {
            Text("Total receipts on file")
                .foregroundStyle(.secondary)
            Text(viewModel.totalAmount, format: AppFormatStyle.Currency.current)
                .xLargeTitle()
                .fontWeight(.bold)
                .redactedShimmer(isShimmering: viewModel.isLoading)
        }
    }
    
    var balanceCards: some View {
        HStack {
            BalanceCard(
                type: .reimbursed,
                amount: viewModel.reimbursedAmount,
                isLoading: viewModel.isLoading
            )
            BalanceCard(
                type: .available,
                amount: viewModel.availableAmount,
                isLoading: viewModel.isLoading
            )
        }
    }
    
    var statusBarView: some View {
        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
            .fill(
                LinearGradient(
                    stops: viewModel.isLoading
                        ? [.init(color: .secondary.opacity(0.3), location: 0)]
                        : [
                            .init(color: .accent, location: viewModel.statusLocation),
                            .init(color: .brandSecondary, location: viewModel.statusLocation)
                        ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 6)
            .redactedShimmer(isShimmering: viewModel.isLoading)
    }
}

// MARK: - Previews

#Preview {
    let mockReceipts = [
        Receipt.mock(),
        Receipt.mock(reimbursementDate: .now),
        Receipt.mock()
    ]
    VStack {
        HomeView.Overview(receipts: mockReceipts, isLoading: false)
        HomeView.Overview(receipts: mockReceipts, isLoading: true)
    }
    .padding()
}
