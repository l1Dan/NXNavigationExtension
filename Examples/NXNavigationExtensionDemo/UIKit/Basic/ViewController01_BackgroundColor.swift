//
//  ViewController01_BackgroundColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController01_BackgroundColor: CustomTableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController01_BackgroundColor {
    override var nx_barTintColor: UIColor? {
        return .white
    }

    override var nx_titleTextAttributes: [NSAttributedString.Key: Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? .white]
    }

    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
}
