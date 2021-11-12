//
//  ViewController01_EdgePopGestureDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController01_EdgePopGestureDisable: CustomTableViewController {

}

extension ViewController01_EdgePopGestureDisable {
    
    override var nx_disableInteractivePopGesture: Bool {
        return true
    }
    
}
