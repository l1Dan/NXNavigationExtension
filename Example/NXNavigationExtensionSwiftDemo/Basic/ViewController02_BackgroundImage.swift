//
//  ViewController02_BackgroundImage.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController02_BackgroundImage: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var nx_navigationBarBackgroundImage: UIImage? {
        return UIImage.navigationBarBackgorund
    }

}
