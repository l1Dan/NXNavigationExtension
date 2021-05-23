//
//  ViewController01_DisablePopGesture.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController01_DisablePopGesture: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var nx_disableInteractivePopGesture: Bool {
        return true
    }
    
}
