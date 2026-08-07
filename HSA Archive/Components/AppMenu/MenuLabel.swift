//
//  MenuLabel.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/4/25.
//

import SwiftUI

struct MenuLabel: View {
    private let selection: Selection
    
    init(selection: Selection) {
        self.selection = selection
    }
    
    var body: some View {
        HStack {
            if let systemImage = selection.systemImage {
                Image(systemName: systemImage)
                    .font(.caption)
            }
            Text(selection.title)
            Image(systemName: "chevron.down")
                .font(.caption)
        }
    }
}

#Preview {
    MenuLabel(selection: .mock)
}
