//
//  MenuLabel.swift
//  climbto350
//
//  Created by Steve Nimcheski on 8/4/25.
//

import SwiftUI

struct MenuLabel: View {
    private let selection: String
    
    init(selection: String) {
        self.selection = selection
    }
    
    var body: some View {
        HStack {
            Text(selection)
            Image(systemName: "chevron.down")
                .font(.caption)
        }
    }
}

#Preview {
    MenuLabel(selection: "Selection")
}
