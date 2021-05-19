//
//  ViewController01_BackgroundColor.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController01_BackgroundColor: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.largeTitleTextAttributes = unx_titleTextAttributes
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
    
    override var unx_barTintColor: UIColor? {
        return .white
    }
    
    override var unx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    override var unx_navigationBarBackgroundColor: UIColor? {
        return .customDarkGray
    }
}
