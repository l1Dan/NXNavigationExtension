//
//  MainTabBarController.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/11/12.
//

import SwiftUI
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        viewControllers = [featureNavigationController, hostingController]
        tabBar.tintColor = UIColor.customColor { .customDarkGray } darkModeColor: { .customLightGray }
    }
    
    private lazy var featureNavigationController: FeatureNavigationController = {
        var featureTableViewController = FeatureTableViewController(style: .grouped)
        featureTableViewController = FeatureTableViewController(style: .insetGrouped)
        let customNormal = UIImage(named: "TabBarCustomNormal")
        let customSelected = UIImage(named: "TabBarCustomSelected")
        
        let featureNavigationController = FeatureNavigationController(rootViewController: featureTableViewController)
        featureTableViewController.navigationItem.title = "UIKit🎉🎉🎉"
        featureNavigationController.tabBarItem = UITabBarItem(title: "UIKit", image: customNormal, selectedImage: customSelected)
        return featureNavigationController
    }()
    
    private lazy var hostingController: UIHostingController<ContentView> = {
        let hostingController = UIHostingController(rootView: ContentView())
        let systemNormal = UIImage(named: "TabBarSystemNormal")
        let systemSelected = UIImage(named: "TabBarSystemSelected")
        hostingController.tabBarItem = UITabBarItem(title: "SwiftUI", image: systemNormal, selectedImage: systemSelected)
        return hostingController
    }()
    
}


extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (UIDevice.isPhoneDevice) { return }
        
        guard var viewControllers = splitViewController?.viewControllers else { return }
        guard let lastViewController = viewControllers.last else { return }
        
        if viewController.isMember(of: type(of: lastViewController.self)) { return }
        
        guard let oldDetailNavigationController = viewControllers.last as? UINavigationController else { return }
        guard let oldDetailViewController = oldDetailNavigationController.viewControllers.last else { return }
        
        let detailViewController = type(of: oldDetailViewController).init()
        detailViewController.navigationItem.title = oldDetailViewController.navigationItem.title
        
        guard let viewController = viewController as? UINavigationController else { return }
        let detailNavigationController = type(of: viewController).init(rootViewController: detailViewController)
        
        _ = viewControllers.firstIndex(of: oldDetailNavigationController).map { viewControllers.remove(at: $0) }
        viewControllers.append(detailNavigationController)
        
        splitViewController?.viewControllers = viewControllers
    }
    
}
