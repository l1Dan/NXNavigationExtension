//
//  ViewController02_FullPopGesture.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController02_FullPopGesture: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var nx_enableFullScreenInteractivePopGesture: Bool {
        return true
    }
    
}
