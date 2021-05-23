//
//  ViewController07_CustomBackButtonImage.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController07_CustomBackButtonImage: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var nx_backImage: UIImage? {
        return UIImage(named: "NavigationBarBack")
    }

}
