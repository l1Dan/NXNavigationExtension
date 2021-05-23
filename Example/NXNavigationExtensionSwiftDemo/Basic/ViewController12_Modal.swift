//
//  ViewController12_Modal.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController12_Modal: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: 0, width: 36.0, height: 36.0)
        closeButton.backgroundColor = .clear
        closeButton.setImage(UIImage(named: "NavigationBarClose")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .customTitle
        closeButton.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
}

@objc
extension ViewController12_Modal {
    
    private func clickCloseButton(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
