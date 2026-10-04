//
//  URL+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 10/2/26.
//

import UIKit

nonisolated extension URL {
    /// Returns the image represented by the URL, or nil if the data is invalid.
    var uiImage: UIImage? {
        guard let data = try? Data(contentsOf: self),
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    /// Returns the image represented by a security-scoped URL, or nil if access fails.
    var securityScopedUIImage: UIImage? {
        guard startAccessingSecurityScopedResource() else { return nil }
        defer { stopAccessingSecurityScopedResource() }
        return uiImage
    }
}

nonisolated extension [URL] {
    /// Returns the images represented by the URLs, excluding URLs that cannot be loaded.
    var uiImages: [UIImage] {
        compactMap(\.uiImage)
    }
    
    /// Returns the images represented by the security-scoped URLs, excluding inaccessible URLs.
    var securityScopedUIImages: [UIImage] {
        compactMap(\.securityScopedUIImage)
    }
}
