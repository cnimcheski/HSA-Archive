//
//  CustomSpacingLabelStyle.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 9/17/26.
//

import SwiftUI

extension LabelStyle where Self == CustomSpacingLabelStyle {
    /// A label style that applies custom spacing between the icon and title.
    static func customSpacing(_ spacing: CGFloat) -> CustomSpacingLabelStyle {
        CustomSpacingLabelStyle(spacing: spacing)
    }
}

struct CustomSpacingLabelStyle: LabelStyle {
    private let spacing: CGFloat
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}
