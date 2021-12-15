//
//  ViewController08_CustomBackView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController08_CustomBackView: CustomTableViewController {

    private lazy var backButton: UIButton = {
        let isRightToLeft = navigationController?.navigationBar.semanticContentAttribute ?? .forceLeftToRight == .forceRightToLeft
        let image = isRightToLeft ? UIImage(named: "NavigationBarBack")?.imageFlippedForRightToLeftLayoutDirection() : UIImage(named: "NavigationBarBack")
        let backButton = UIButton(type: .custom)
        backButton.setTitle("😋", for: .normal)
        backButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        return backButton
    }()
    
}

extension ViewController08_CustomBackView {
    
    override var nx_backButtonCustomView: UIView? {
        return backButton
    }
    
}
