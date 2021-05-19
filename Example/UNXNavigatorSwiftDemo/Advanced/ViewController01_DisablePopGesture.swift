//
//  ViewController01_DisablePopGesture.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController01_DisablePopGesture: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var unx_disableInteractivePopGesture: Bool {
        return true
    }
    
}
