//
//  UIColor+Extensions.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import UIKit
import NXNavigationExtension

extension UIColor {
    
    private static var randomColor: UIColor {
        let red = CGFloat.random(in: 10...350) / 360.0
        let green = CGFloat.random(in: 10...350) / 360.0
        let blue = CGFloat.random(in: 10...350) / 360.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static var randomLight: UIColor {
        var hue = CGFloat(0.0)
        var saturation = CGFloat(0.0)
        var brightness = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        randomColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        if saturation > 0.5 {
            saturation -= CGFloat.random(in: 0.0..<0.5)
        }
        
        if brightness < 0.5 {
            brightness += CGFloat.random(in: 0.0..<0.5)
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    static var randomDark: UIColor {
        var hue = CGFloat(0.0)
        var saturation = CGFloat(0.0)
        var brightness = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        randomColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        if saturation < 0.5 {
            saturation += CGFloat.random(in: 0.0..<0.5)
        }
        
        if brightness > 0.5 {
            brightness -= CGFloat.random(in: 0.0..<0.5)
        }
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    static var customTitle: UIColor {
        return UIColor.customColor {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // .black
        } darkModeColor: {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // .white
        }
    }
    
    static var customDarkGray: UIColor {
        return UIColor(red: 25 / 255.0, green: 43 / 255.0, blue: 67 / 255.0, alpha: 1.0)
    }
    
    static var customLightGray: UIColor {
        return UIColor(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 1.0)
    }
    
    static func mix(color1: UIColor, color2: UIColor, ratio: CGFloat) -> UIColor {
        var ratio = ratio
        if ratio > 1 { ratio = 1.0 }
        
        guard let components1 = color1.cgColor.components,
              let components2 = color2.cgColor.components else { return UIColor.clear }
        
        let red = components1[0] * ratio + components2[0] * (1.0 - ratio)
        let green = components1[1] * ratio + components2[1] * (1.0 - ratio)
        let blue = components1[2] * ratio + components2[2] * (1.0 - ratio)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static func customColor(lightModeColor: @escaping () -> UIColor, darkModeColor: @escaping () -> UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkModeColor()
                }
                return lightModeColor()
            }
        }
        return lightModeColor()
    }
    
}

extension UIDevice {
    
    static var isPhoneDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
}

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
        if #available(iOS 13.0, *) {
            return currentKeyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func setStatusBarStyle(_ style: UIUserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            currentKeyWindow?.overrideUserInterfaceStyle = style
            currentKeyWindow?.setNeedsLayout()
        }
    }
    
}

extension UIImage {
    
    @MainActor
    static var navigationBarBackground: UIImage? {
        let statusBarHeight = UIApplication.shared.statusBarHeight
        return statusBarHeight <= 20.0 ? UIImage(named: "NavigationBarBackground64") : UIImage(named: "NavigationBarBackground88")
    }
    
}

extension String {
    
    var removeModuleName: String {
        return self.components(separatedBy: ".").last ?? ""
    }
    
}

extension NXNavigationTransitionState: @retroactive CustomStringConvertible {
    public var description: String {
        let prefix = "TransitionState: "
        switch self {
        case .unspecified: return prefix + "Unspecified"
        case .willPush: return prefix + "WillPush"
        case .didPush: return prefix + "DidPush"
        case .pushCancelled: return prefix + "PushCancelled"
        case .pushCompleted: return prefix + "PushCompleted"
        case .willPop: return prefix + "WillPop"
        case .didPop: return prefix + "DidPop"
        case .popCancelled: return prefix + "PopCancelled"
        case .popCompleted: return prefix + "PopCompleted"
        case .willSet: return prefix + "WillSet"
        case .didSet: return prefix + "DidSet"
        case .setCancelled: return prefix + "SetCancelled"
        case .setCompleted: return prefix + "SetCompleted"
        @unknown default: return prefix + "None"
        }
    }
}
