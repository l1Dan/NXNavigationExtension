//
//  ViewController09_FullScreen.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import NXNavigationExtension

class ViewController09_FullScreen: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }

}
