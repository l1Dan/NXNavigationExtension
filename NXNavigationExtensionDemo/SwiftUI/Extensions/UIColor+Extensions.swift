//
//  UIColor+Extensions.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import UIKit

extension UIColor {

    static var randomLight: UIColor {
        let hue = CGFloat.random(in: 0...255.0) / 256.0;
        let saturation = CGFloat.random(in: 0...128.0) / 256.0 + 0.5;
        let brightness = CGFloat.random(in: 0...128.0) / 256.0 + 0.5;
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static var randomDark: UIColor {
        let hue = CGFloat.random(in: 0...255.0) / 256.0;
        let saturation = CGFloat.random(in: 0...128.0) / 256.0 + 0.5;
        let brightness = CGFloat.random(in: 0...128.0) / 256.0;
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    static var customTitle: UIColor {
        return UIColor.customColor {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // .black
        } darkModeColor: {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // .white
        }
    }
    
    static var customText: UIColor {
        return UIColor.customColor {
            return .customDarkGray
        } darkModeColor: {
            return .customLightGray
        }
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

    static var customBackground: UIColor {
        return UIColor.customColor {
            return .white
        } darkModeColor: {
            if #available(iOS 13.0, *) {
                return .systemGray6
            } else {
                return .white
            }
        }
    }

    static var customGroupedBackground: UIColor {
        return UIColor.customColor {
            return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0) // .groupTableViewBackground
        } darkModeColor: {
            if #available(iOS 13.0, *) {
                return UIColor.systemGroupedBackground
            } else {
                return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0) // .groupTableViewBackground
            }
        }
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

