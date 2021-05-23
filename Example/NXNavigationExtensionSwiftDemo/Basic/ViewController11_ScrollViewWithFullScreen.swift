//
//  ViewController11_ScrollViewWithFullScreen.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController11_ScrollViewWithFullScreen: ViewController10_ScrollView {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        
        #if targetEnvironment(macCatalyst)
        let maxHeight = nx_navigationBar.frame.height
        tableView.contentInset = UIEdgeInsets(top: -maxHeight, left: 0.0, bottom: 0.0, right: 0.0)
        #endif
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        #if !targetEnvironment(macCatalyst)
        let maxHeight = nx_navigationBar.frame.height
        tableView.contentInset = UIEdgeInsets(top: -maxHeight, left: 0.0, bottom: 0.0, right: 0.0)
        #endif
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var nx_barTintColor: UIColor? {
        return .white
    }
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return .clear
    }

}
