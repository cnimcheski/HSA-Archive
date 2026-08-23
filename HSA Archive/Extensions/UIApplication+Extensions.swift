//
//  UIApplication+Extensions.swift
//  HSA Archive
//
//  Created by Steve Nimcheski on 8/11/26.
//

import UIKit

extension UIApplication {
    /// Gets the top view controller for showing Google Sign In sheet.
    func getTopViewController() -> UIViewController? {
        var topController = connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .rootViewController
        
        // Ensures any presented views will be treated as 'top-most' viewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }
}
