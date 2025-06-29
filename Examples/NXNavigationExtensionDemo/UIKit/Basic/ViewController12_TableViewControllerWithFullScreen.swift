//
//  ViewController12_TableViewControllerWithFullScreen.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController12_TableViewControllerWithFullScreen: ViewController11_TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nil

        tableView.contentInsetAdjustmentBehavior = .never
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController12_TableViewControllerWithFullScreen {
    override var nx_barTintColor: UIColor? {
        return .white
    }

    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }

    override var nx_shadowColor: UIColor? {
        return .clear
    }
}
