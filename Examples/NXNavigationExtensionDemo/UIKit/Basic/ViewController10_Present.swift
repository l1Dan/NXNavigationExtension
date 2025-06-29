//
//  ViewController10_Present.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import NXNavigationExtension
import UIKit

class ViewController10_Present: CustomTableViewController {
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        closeButton.backgroundColor = .clear
        closeButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .customTitle
        closeButton.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: closeButton)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    @objc
    private func clickCloseButton(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController10_Present {
    override var nx_navigationBarBackgroundColor: UIColor? {
        return .clear
    }

    override var nx_useBlurNavigationBar: Bool {
        return true
    }
}
