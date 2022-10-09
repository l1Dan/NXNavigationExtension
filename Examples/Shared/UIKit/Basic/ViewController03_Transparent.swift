//
//  ViewController03_Transparent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController03_Transparent: CustomTableViewController {

}

extension ViewController03_Transparent {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowColor: UIColor? {
        return .clear
    }
    
}
