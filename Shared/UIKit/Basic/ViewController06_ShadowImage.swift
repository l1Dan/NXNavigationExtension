//
//  ViewController06_ShadowImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController06_ShadowImage: BaseViewController {

}

extension ViewController06_ShadowImage {
    
    override var nx_shadowImage: UIImage? {
        return UIImage(named: "NavigationBarShadowImage")
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return view.backgroundColor
    }

}
