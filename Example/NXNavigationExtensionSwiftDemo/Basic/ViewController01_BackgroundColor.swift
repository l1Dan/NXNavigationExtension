//
//  ViewController01_BackgroundColor.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController01_BackgroundColor: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.largeTitleTextAttributes = nx_titleTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
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

    override var nx_navigationBarBackgroundColor: UIColor? {
        return .customDarkGray
    }
}
