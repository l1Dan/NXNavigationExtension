//
//  ViewController02_BackgroundImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController02_BackgroundImage: CustomTableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ViewController02_BackgroundImage {
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? .white]
    }
    
    override var nx_navigationBarBackgroundImage: UIImage? {
        return UIImage.navigationBarBackground
    }
    
}
