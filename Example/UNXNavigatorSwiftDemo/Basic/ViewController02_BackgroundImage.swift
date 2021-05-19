//
//  ViewController02_BackgroundImage.swift
//  UNXNavigatorSwiftDemo
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
    
    override var unx_barTintColor: UIColor? {
        return .white
    }
    
    override var unx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var unx_navigationBarBackgroundImage: UIImage? {
        return UIImage.navigationBarBackgorund
    }

}
