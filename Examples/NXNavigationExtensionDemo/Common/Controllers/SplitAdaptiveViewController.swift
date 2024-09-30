//
//  SplitAdaptiveViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/14.
//

import UIKit

class SplitAdaptiveViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let tabBarController = MainTabBarController()
        let viewController = ViewController01_BackgroundColor()
        viewController.navigationItem.title = NavigationFeatureSection.sections(for: true).first?.items.first?.title;
        viewControllers = [tabBarController, SlidingNavigationController(rootViewController: viewController)]
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return UIDevice.isPhoneDevice ? self.viewControllers.last : nil
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return UIDevice.isPhoneDevice ? self.viewControllers.last : nil
    }

}

