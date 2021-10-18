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
        featureConfiguration.registerNavigationControllerClasses([FeatureNavigationController.self]) { viewController, configuration in
            configuration.navigationBarAppearance.backgroundColor = .brown
            return configuration
        }
        
        // For SwiftUI
        if #available(iOS 13.0, *) {
            let defaultConfiguration = NXNavigationConfiguration()
            defaultConfiguration.navigationBarAppearance.tintColor = .black
            defaultConfiguration.navigationBarAppearance.backgroundColor = .white
            defaultConfiguration.navigationBarAppearance.useSystemBackButton = true // Requirements for SwiftUI
            
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
            
            defaultConfiguration.registerNavigationControllerClasses(classes)
        }
    }
}

