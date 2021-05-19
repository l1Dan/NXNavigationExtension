//
//  ViewController06_ShadowImage.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class ViewController06_ShadowImage: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var unx_shadowImage: UIImage? {
        return UIImage(named: "NavigationBarShadowImage")
    }

}
