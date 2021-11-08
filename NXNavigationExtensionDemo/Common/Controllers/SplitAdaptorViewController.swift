//
//  SplitAdaptorViewController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/14.
//

import UIKit

class SplitAdaptorViewController: UISplitViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let tabBarController = MainTabBarController()
        let viewController = ViewController01_BackgroundColor()
        viewController.navigationItem.title = NavigationFeatureSection.sections(for: true).first?.items.first?.title;
        viewControllers = [tabBarController, FeatureNavigationController(rootViewController: viewController)]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return UIDevice.isPhoneDevice ? self.viewControllers.last : nil
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return UIDevice.isPhoneDevice ? self.viewControllers.last : nil
    }

}

