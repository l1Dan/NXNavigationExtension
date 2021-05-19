//
//  ViewController09_FullScreen.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import UNXNavigator

class ViewController09_FullScreen: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var unx_barTintColor: UIColor? {
        return .white
    }
    
    override var unx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var unx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }
    
    override var unx_shadowImageTintColor: UIColor? {
        return .clear
    }

}
