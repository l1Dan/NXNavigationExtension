//
//  DashboardTabBarController.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import UNXNavigator

class DashboardTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNXNavigationBar.Appearance.standard.tintColor = .customTitle
        UNXNavigationBar.registerStandardAppearance(forNavigationControllerClass: FeatureNavigationController.self)
        
        let featureTableViewController1 = FeatureTableViewController(style: .grouped)
        let name = (Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String)?.components(separatedBy: ".").last ?? ""
        featureTableViewController1.navigationItem.title = "\(name) 🎉 🎉 🎉"
        
        let customNormal = UIImage(named: "TabBarCustomNormal")
        let customSelected = UIImage(named: "TabBarCustomSelected")
        let navigationController1 = FeatureNavigationController(rootViewController: featureTableViewController1)
        navigationController1.tabBarItem = UITabBarItem(title: "Custom", image: customNormal, selectedImage: customSelected)
        
        let featureTableViewController2 = FeatureTableViewController(style: .grouped)
        featureTableViewController2.navigationItem.title = "UINavigationBar⚠️⚠️⚠️"
        
        let systemNormal = UIImage(named: "TabBarSystemNormal")
        let systemSelected = UIImage(named: "TabBarSystemSelected")
        let navigationController2 = BaseNavigationController(rootViewController: featureTableViewController2)
        navigationController2.tabBarItem = UITabBarItem(title: "System", image: systemNormal, selectedImage: systemSelected)
        
        delegate = self;
        viewControllers = [navigationController1, navigationController2]

        // ⚠️Warning!!!
        navigationController2.view.layer.borderWidth = 3.0
        navigationController2.view.layer.cornerRadius = 40
        navigationController2.view.layer.borderColor = UIColor.customDynamic(lightMode: { UIColor.red }, darkMode: { UIColor.red.withAlphaComponent(0.5) }).cgColor
        
        tabBar.tintColor = UIColor.customDynamic(lightMode: { .customDarkGray }, darkMode: { () -> UIColor in .customLightGray })
        tabBar.unselectedItemTintColor = UIColor.customDynamic(lightMode: { .customLightGray }, darkMode: { () -> UIColor in .customDarkGray })
        tabBar.isTranslucent = false // FIXED: iOS Modal -> Dismiss -> Push, TabBar BUG
    }

}

extension DashboardTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UIDevice.isPhone { return }
        
        guard let last = splitViewController?.viewControllers.last, last.isMember(of: type(of: viewController)) else {
            return
        }
        
        guard var viewControllers = splitViewController?.viewControllers,
              let oldDetailNavigationController = viewControllers.last as? UINavigationController,
              let oldDetailViewController = oldDetailNavigationController.viewControllers.last else { return }
        
        guard let DetailNavigationController = type(of: viewController) as? UINavigationController.Type else { return }
        let detailViewController = type(of: oldDetailViewController).init()
        detailViewController.navigationItem.title = oldDetailViewController.navigationItem.title
        let detailNavigationController = DetailNavigationController.init(rootViewController: detailViewController)

        if let index = viewControllers.firstIndex(of: oldDetailNavigationController) {
            viewControllers.remove(at: index)
            viewControllers.append(detailNavigationController)
            splitViewController?.viewControllers = viewControllers
        }
    }
}
