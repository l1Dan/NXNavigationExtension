//
//  ViewController03_Transparent.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController03_Transparent: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }

}
