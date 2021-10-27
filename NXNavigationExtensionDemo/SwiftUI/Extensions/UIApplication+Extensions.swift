//
//  UIApplication+Extensions.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/27.
//

import UIKit

@available(iOS 13, *)
extension UIApplication {
    
    var currentKeyWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            return connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap { $0 as? UIWindowScene }?.windows
                .first(where: \.isKeyWindow)
        } else {
            return windows.filter { $0.isKeyWindow }.first
        }
    }
    
    var statusBarHeight: CGFloat {
        return currentKeyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    func setStatusBarStyle(_ style: UIUserInterfaceStyle) {
        currentKeyWindow?.overrideUserInterfaceStyle = style
        currentKeyWindow?.setNeedsLayout()
    }
    
}
