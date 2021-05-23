//
//  Extensions.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

extension UIColor {
    
    static var randomLight: UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256.0 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static var randomDark: UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256.0
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static var customDarkGray: UIColor {
        return UIColor(red: 25 / 255.0, green: 43 / 255.0, blue: 67 / 255.0, alpha: 1.0)
    }
    
    static var customLightGray: UIColor {
        return UIColor(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 1.0)
    }
    
    static var customBlue: UIColor {
        return UIColor(red: 0.0, green: 122 / 255.0, blue: 1.0, alpha: 1.0) // .systemBlue
    }
    
    static var customTitle: UIColor {
        return UIColor.customDynamic {
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // !UIColor.black
        } darkMode: {
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // !UIColor.white
        }
    }
    
    static var customText: UIColor {
        return UIColor.customDynamic { .customDarkGray } darkMode: { .customLightGray }
    }
    
    static var customBackground: UIColor {
        return UIColor.customDynamic {
            return UIColor.white
        } darkMode: {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray6
            } else {
                return UIColor.white
            }
        }
    }
    
    static var customGroupedBackground: UIColor {
        return UIColor.customDynamic {
            return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0) // .groupTableViewBackground
        } darkMode: {
            if #available(iOS 13.0, *) {
                return UIColor.systemGroupedBackground
            } else {
                return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0) // .groupTableViewBackground
            }
        }
    }
    
    
    static func customDynamic(lightMode: @escaping () -> UIColor, darkMode: @escaping () -> UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkMode()
                }
                return lightMode()
            }
        } else {
            return lightMode()
        }
    }
    
    static func mix(color1: UIColor, color2: UIColor, ratio: CGFloat) -> UIColor? {
        var ratio = ratio
        if(ratio > 1.0) { ratio = 1.0 }
        
        guard let components1 = color1.cgColor.components else { return nil }
        guard let components2 = color2.cgColor.components else { return nil }
        
        let r = components1[0] * ratio + components2[0] * (1 - ratio);
        let g = components1[1] * ratio + components2[1] * (1 - ratio);
        let b = components1[2] * ratio + components2[2] * (1 - ratio);
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}

extension UIDevice {
    
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
}

extension UIImage {
    
    static var navigationBarBackgorund: UIImage? {
        var statusBarHeight: CGFloat? = 20.0
        
        var keyWindow = UIApplication.shared.windows.first
        for window in UIApplication.shared.windows {
            if window.isKeyWindow { keyWindow = window }
        }
        
        #if targetEnvironment(macCatalyst)
        statusBarHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height
        #else
        if #available(iOS 13.0, *) {
            statusBarHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        #endif

        return (statusBarHeight ?? 20.0) <= 20.0 ? UIImage(named: "NavigationBarBackgound64") : UIImage(named: "NavigationBarBackgound88")
    }
    
}

extension UITableViewCell {
    
    func setCellClick(enabled: Bool) {
        isUserInteractionEnabled = enabled
        alpha = enabled ? 1.0 : 0.5
        for view in subviews {
            view.isUserInteractionEnabled = enabled
            view.alpha = enabled ? 1.0 : 0.5
        }
    }
    
}

extension String {
    
    private var namespace: String? {
        return Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    }
    
    var toAnyClass: AnyClass? {
        guard let namespace = namespace else { return nil }
        return NSClassFromString("\(namespace.replacingOccurrences(of: " ", with: "_")).\(self)")
    }
    
    var toClassName: String? {
        return self.components(separatedBy: ".").last
    }
    
}
