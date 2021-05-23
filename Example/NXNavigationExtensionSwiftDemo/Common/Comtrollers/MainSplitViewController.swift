//
//  MainSplitViewController.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let tabBarController = DashboardTabBarController()
        let viewController = ViewController01_BackgroundColor()
        viewController.navigationItem.title = TableViewSection.makeAllSections().first?.items.first?.itemType.rawValue
        viewControllers = [tabBarController, FeatureNavigationController(rootViewController: viewController)]
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return UIDevice.isPhone ? viewControllers.last : nil
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return UIDevice.isPhone ? viewControllers.last : nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
