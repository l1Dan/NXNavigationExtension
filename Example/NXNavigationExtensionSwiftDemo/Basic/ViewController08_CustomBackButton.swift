//
//  ViewController08_CustomBackButton.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController08_CustomBackButton: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var nx_backButtonCustomView: UIView? {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("😋", for: .normal)
        backButton.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitleColor(.customDarkGray, for: .normal)
        return backButton
    }

}
