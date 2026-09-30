//
//  GrowthView+ProjectionSummary.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/28/26.
//

import SwiftUI

extension GrowthView {
    struct ProjectionSummary: View {
        private let viewModel: ViewModel
        
        init(years: Int, currentAmount: Double, projectedAmount: Double, isLoading: Bool) {
            self.viewModel = .init(
                years: years,
                currentAmount: currentAmount,
                projectedAmount: projectedAmount,
                isLoading: isLoading
            )
        }
        
        var body: some View {
            AppGroupBox {
                content
                    .animation(.easeInOut, value: viewModel.projectedAmount)
                    .contentTransition(.numericText())
            } label: {
                Text("Projected balance in ^[\(viewModel.years) year](inflect: true)")
            }
        }
    }
}

// MARK: - Private Views

private extension GrowthView.ProjectionSummary {
    var content: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            projectedAmountText
            Divider()
            currentAmountRow
            Divider()
            projectedGrowthRow
        }
    }
    
    var projectedAmountText: some View {
        Text(viewModel.projectedAmount.formatted(AppFormatStyle.Currency.current))
            .font(.largeTitle)
            .bold()
            .redactedShimmer(isShimmering: viewModel.isLoading)
    }
    
    func amountRow<S: ShapeStyle>(
        _ label: LocalizedStringResource,
        amount: String,
        amountStyle: S = .primary
    ) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(amount)
                .foregroundStyle(amountStyle)
                .redactedShimmer(isShimmering: viewModel.isLoading)
        }
    }
    
    var currentAmountRow: some View {
        amountRow(
            "Balance today",
            amount: viewModel.currentAmount.formatted(AppFormatStyle.Currency.current)
        )
    }
    
    var projectedGrowthRow: some View {
        amountRow(
            "Projected growth",
            amount: "+\(viewModel.growthAmount.formatted(AppFormatStyle.Currency.current))",
            amountStyle: .accent
        )
    }
}

// MARK: - Previews

#Preview {
    List {
        GrowthView.ProjectionSummary(years: 30, currentAmount: 21.34, projectedAmount: 100, isLoading: false)
        GrowthView.ProjectionSummary(years: 30, currentAmount: 21.34, projectedAmount: 100, isLoading: true)
    }
    .listStyle(.plain)
}
