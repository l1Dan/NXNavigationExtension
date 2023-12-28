//
//  ViewController01_EdgePopGestureDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit
import NXNavigationExtension

class ViewController01_EdgePopGestureDisable: CustomTableViewController {

}

extension ViewController01_EdgePopGestureDisable {
    
    func nx_navigationController(_ navigationController: UINavigationController, transitionViewController viewController: UIViewController, navigationBackAction action: NXNavigationBackAction) -> Bool {
        if case .interactionGesture = action {
            return false
        }
        return true
    }
    
}
