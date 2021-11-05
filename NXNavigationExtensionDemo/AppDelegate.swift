//
//  AppDelegate.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/14.
//

import NXNavigationExtension
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupConfiguration()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .customBackground
        window?.rootViewController = SplitAdaptorViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()

        return true
    }

}

extension AppDelegate {
    
    private func setupConfiguration() {
        // For FeatureNavigationController
        let featureConfiguration = NXNavigationConfiguration.default
        featureConfiguration.navigationBarAppearance.tintColor = .customTitle
        featureConfiguration.registerNavigationControllerClasses([FeatureNavigationController.self]) { navigationController, configuration in
            configuration.navigationBarAppearance.backgroundColor = .brown
            
            print("UIKit(navigationController):", navigationController, configuration)
            navigationController.nx_prepareConfigureViewControllersCallback { viewController, configuration in
                print("UIKit(viewController):", viewController, configuration)
            }
            
            return configuration
        }
        
        // For SwiftUI
        if #available(iOS 13.0, *) {
            var classes: [AnyClass] = []
            if #available(iOS 15.0, *) {
                classes = [
                    NSClassFromString("SwiftUI.SplitViewNavigationController"),
                    NSClassFromString("SwiftUI.UIKitNavigationController"),
                ].compactMap { $0 }
            } else {
                classes = [
                    NSClassFromString("SwiftUI.SplitViewNavigationController"), // iOS14
                    UINavigationController.self, // Requirements for SwiftUI in iOS13
                ].compactMap { $0 }
            }
            
            NXNavigationConfiguration().registerNavigationControllerClasses(classes) { navigationController, configuration in
                // Default dynamic colors
                let color = UIColor.customColor { return .black } darkModeColor: { return .white }
                if let traitCollection = configuration.viewControllerPreferences.traitCollection {
                    configuration.navigationBarAppearance.tintColor = color.resolvedColor(with: traitCollection)
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color.resolvedColor(with: traitCollection)]
                } else {
                    configuration.navigationBarAppearance.tintColor = color
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
                }
                
                print("SwiftUI(navigationController):", navigationController, configuration)
                navigationController.nx_prepareConfigureViewControllersCallback { viewController, configuration in
                    print("SwiftUI(viewController):", viewController, configuration)
                }
                
                return configuration
            }
        }
    }
}

