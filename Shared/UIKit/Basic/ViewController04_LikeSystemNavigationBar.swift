//
//  ViewController04_LikeSystemNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController04_LikeSystemNavigationBar: CustomTableViewController {

}

extension ViewController04_LikeSystemNavigationBar {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
//        return .purple.withAlphaComponent(0.5)
        return .clear
    }
    
    override var nx_useBlurNavigationBar: Bool {
        return true
    }
    
}
