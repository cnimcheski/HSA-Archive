//
//  DotSeparator.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/10/26.
//

import SwiftUI

struct DotSeparator: View {
    private let leftText: String
    private let rightText: String
    private let spacing: CGFloat
    
    init(
        leftText: String,
        rightText: String,
        spacing: CGFloat = Theme.Spacing.small
    ) {
        self.leftText = leftText
        self.rightText = rightText
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            Text(leftText)
            Circle()
                .frame(width: 4)
            Text(rightText)
        }
    }
}

// MARK: - Previews

#Preview {
    DotSeparator(
        leftText: "July 8",
        rightText: "Prescription"
    )
}
