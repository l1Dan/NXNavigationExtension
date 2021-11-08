//
//  ViewController08_CustomBackView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController08_CustomBackView: CustomTableViewController {

    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("😋", for: .normal)
        backButton.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return backButton
    }()
    
}

extension ViewController08_CustomBackView {
    
    override var nx_backButtonCustomView: UIView? {
        return backButton
    }
    
}
