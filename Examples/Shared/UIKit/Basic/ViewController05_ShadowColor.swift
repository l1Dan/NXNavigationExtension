//
//  ViewController05_ShadowColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController05_ShadowColor: BaseViewController {

}

extension ViewController05_ShadowColor {
    
    override var nx_shadowImageTintColor: UIColor? {
        return .red
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return view.backgroundColor
    }
    
}
