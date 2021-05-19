//
//  ViewController03_Transparent.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController03_Transparent: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var unx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var unx_shadowImageTintColor: UIColor? {
        return .clear
    }

}
