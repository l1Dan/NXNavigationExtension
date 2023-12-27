//
//  AppDelegate.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/14.
//

import UIKit
import NXNavigationExtension

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupConfiguration()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplitAdaptiveViewController(nibName: nil, bundle: nil)
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
            print("UIKit(navigationController):", navigationController, configuration)
            navigationController.nx_prepareConfigureViewControllersCallback { viewController, configuration in
                print("UIKit(viewController):", viewController, configuration)
            }
            return configuration
        }
    }
}

