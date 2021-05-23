//
//  BaseNavigationController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

}
