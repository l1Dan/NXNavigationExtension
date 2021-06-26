//
//  BaseViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class BaseViewController: UIViewController {

    private(set) var randomColor: UIColor?
    
    private lazy var lightColor: UIColor = UIColor.randomLight
    private lazy var darkColor: UIColor = UIColor.randomDark
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .customBackground
        
        randomColor = UIColor.customDynamic(lightMode: { [weak self] in
            guard let self = self else { return UIColor.randomLight }
            return self.lightColor
        }, darkMode: {  [weak self] in
            guard let self = self else { return UIColor.randomDark }
            return self.darkColor
        })
    }
    
    override var nx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.customTitle]
    }
    
    override var nx_barTintColor: UIColor? {
        return .customTitle
    }
    
    override var nx_shadowImageTintColor: UIColor? {
        return UIColor.customDynamic { UIColor.lightGray } darkMode: { UIColor.lightGray.withAlphaComponent(0.65) }
    }

}
