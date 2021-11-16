//
//  ViewController09_FullScreenColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController09_FullScreenColor: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ViewController09_FullScreenColor {
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: nx_barTintColor ?? .white]
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }
    
}
