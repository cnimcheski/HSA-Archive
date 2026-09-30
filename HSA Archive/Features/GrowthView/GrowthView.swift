//
//  GrowthView.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/26/26.
//

import FactoryKit
import SwiftUI

struct GrowthView: View {
    @Bindable private var viewModel: ViewModel
    @InjectedObservable(\.receiptRepository) private var receiptRepository
    @InjectedObservable(\.userDefaultsManager) private var userDefaultsManager
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle("Growth")
    }
}

// MARK: - Private Views

private extension GrowthView {
    var content: some View {
        List {
            projectionContent
            annualReturnSlider
            yearsSlider
        }
        .listStyle(.plain)
    }
    
    var projectionContent: some View {
        VStack {
            ProjectionSummary(
                years: Int(userDefaultsManager.yearsUntilRetirement),
                currentAmount: viewModel.currentAmount,
                projectedAmount: viewModel.projectedAmount,
                isLoading: receiptRepository.isLoading
            )
            GrowthChart(series: viewModel.series)
        }
        .listRowSeparator(.hidden)
    }
    
    var annualReturnSlider: some View {
        AppSlider(
            "Assumed annual return",
            value: $userDefaultsManager.assumedAnnualReturn,
            in: 0...0.2,
            step: 0.005,
            displayValue: "\(userDefaultsManager.assumedAnnualReturn.formatted(.percent))",
            isLoading: receiptRepository.isLoading
        )
    }
    
    var yearsSlider: some View {
        AppSlider(
            "Years until retirement",
            value: $userDefaultsManager.yearsUntilRetirement,
            in: 1...50,
            displayValue: "^[\(Int(userDefaultsManager.yearsUntilRetirement)) year](inflect: true)",
            isLoading: receiptRepository.isLoading
        )
    }
}

// MARK: - Previews

#Preview {
    GrowthView(viewModel: .init())
}
