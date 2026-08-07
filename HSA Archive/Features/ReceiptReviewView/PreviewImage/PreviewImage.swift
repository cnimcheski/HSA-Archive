//
//  PreviewImage.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/7/26.
//

import SwiftUI

struct PreviewImage: View {
    private let uiImage: UIImage
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    var body: some View {
        // Use the parent's available width so the image fills its container and clips correctly.
        GeometryReader { proxy in
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Spacing.large))
        }
        .frame(height: 200)
    }
}

#Preview {
    PreviewImage(uiImage: .init(systemName: "list.bullet.rectangle.fill")!)
        .padding()
}
