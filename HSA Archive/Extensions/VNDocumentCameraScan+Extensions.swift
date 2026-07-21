//
//  VNDocumentCameraScan+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 7/19/26.
//

import VisionKit

extension VNDocumentCameraScan {
    /// Converts a `VNDocumentCameraScan` into an array of `UIImage`.
    var images: [UIImage] {
        (0..<pageCount).map(imageOfPage)
    }
}
