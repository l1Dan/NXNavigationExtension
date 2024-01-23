//
//  MainTabBarController.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        // fix: iOS Modal -> Dismiss -> Push, TabBar BUG
        tabBar.isTranslucent = false
        updateOtherNavigationControllerBorderStyle()
        viewControllers = [slidingNavigationController, otherNavigationController]
        
        tabBar.tintColor = UIColor.customColor { .customDarkGray } darkModeColor: { .customLightGray }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) { } else {
            updateOtherNavigationControllerBorderStyle()
        }
    }
    
    private lazy var slidingNavigationController: SlidingNavigationController = {
        var viewController = FeatureTableViewController(style: .grouped)
        if #available(iOS 13.0, *) {
            viewController = FeatureTableViewController(style: .insetGrouped)
        }
        
        let customNormal = UIImage(named: "TabBarCustomNormal")
        let customSelected = UIImage(named: "TabBarCustomSelected")
        
        let navigationController = SlidingNavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "NXNavigationBar"
        navigationController.tabBarItem = UITabBarItem(title: "Custom", image: customNormal, selectedImage: customSelected)
        return navigationController
    }()
    
    private lazy var otherNavigationController: OtherNavigationController = {
        var viewController = FeatureTableViewController(style: .grouped)
        if #available(iOS 13.0, *) {
            viewController = FeatureTableViewController(style: .insetGrouped)
        }
        
        viewController.navigationItem.title = "UINavigationBar"
        
        let systemNormal = UIImage(named: "TabBarSystemNormal")
        let systemSelected = UIImage(named: "TabBarSystemSelected")
        
        let navigationController = OtherNavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "System", image: systemNormal, selectedImage: systemSelected)
        navigationController.view.layer.borderWidth = 3.0
        return navigationController
    }()
    
}

extension MainTabBarController {
    
    private func updateOtherNavigationControllerBorderStyle() {
        otherNavigationController.view.layer.borderColor = UIColor.customColor { .red } darkModeColor: { .orange }.cgColor
    }
    
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
