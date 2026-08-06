//
//  PreviewInput.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/6/26.
//

import SwiftUI

/// A container view for all custom input component previews.
/// Used to show loading/not loading state variations for all inputs.
struct PreviewInput<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Group {
                content
            }
            .padding()
            .border(.primary)
        }
    }
}

#Preview {
    PreviewInput {
        Group {
            Text("hello")
            Text("hello")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
