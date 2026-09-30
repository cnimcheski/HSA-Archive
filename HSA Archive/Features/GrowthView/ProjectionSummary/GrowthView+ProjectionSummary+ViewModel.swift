//
//  GrowthView+ProjectionSummary+ViewModel.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/28/26.
//

extension GrowthView.ProjectionSummary {
    final class ViewModel {
        let years: Int
        let currentAmount: Double
        let projectedAmount: Double
        let isLoading: Bool
        
        var growthAmount: Double {
            projectedAmount - currentAmount
        }
        
        init(years: Int, currentAmount: Double, projectedAmount: Double, isLoading: Bool) {
            self.years = years
            self.currentAmount = currentAmount
            self.projectedAmount = projectedAmount
            self.isLoading = isLoading
        }
    }
}
