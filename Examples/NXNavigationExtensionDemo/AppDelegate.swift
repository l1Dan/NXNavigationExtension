//
//  AppDelegate.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2024/9/30.
//

import UIKit
import SwiftUI
import NXNavigationExtension
import NXNavigationExtensionSwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupConfiguration()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    private func setupConfiguration() {
        // For SlidingNavigationController
        let featureConfiguration = NXNavigationConfiguration.default
        featureConfiguration.navigationBarAppearance.tintColor = .customTitle
        featureConfiguration.registerNavigationControllerClasses([SlidingNavigationController.self]) { navigationController, configuration in
            print("UIKit(navigationController):", navigationController, configuration)
            navigationController.nx_prepareConfigureViewControllersCallback { viewController, configuration in
                print("UIKit(viewController):", viewController, configuration)
            }
            
            return configuration
        }
        
        // 自定义查找规则
        @available(iOS 14.0, *)
        func configureWithCustomRule(for hostingController: UIViewController) -> NXNavigationVirtualView? {
            guard let view = hostingController.view else { return nil }
            if let navigationVirtualWrapperView = hostingController.nx_navigationVirtualWrapperView as? NXNavigationVirtualView {
                return navigationVirtualWrapperView
            }
            
            let hostingViewClassName = NSStringFromClass(type(of: view))
            guard hostingViewClassName.contains("SwiftUI") || hostingViewClassName.contains("HostingView") else { return nil }
            
            var navigationVirtualWrapperView: NXNavigationVirtualView?
            for wrapperView in view.subviews {
                let wrapperViewClassName = NSStringFromClass(type(of: wrapperView))
                if wrapperViewClassName.contains("ViewHost") && wrapperViewClassName.contains("NXNavigationWrapperView") {
                    for subview in wrapperView.subviews {
                        if let virtualWrapperView = subview as? NXNavigationVirtualView {
                            navigationVirtualWrapperView = virtualWrapperView
                            break
                        }
                    }
                }
            }
            
            return navigationVirtualWrapperView
        }
        
        // For SwiftUI
        var classes: [AnyClass] = []
        if #available(iOS 15.0, *) {
            classes = [
                NSClassFromString("SwiftUI.SplitViewNavigationController"),
                NSClassFromString("SwiftUI.UIKitNavigationController"),
            ].compactMap { $0 }
        } else {
            classes = [
                NSClassFromString("SwiftUI.SplitViewNavigationController"),
                UINavigationController.self,
            ].compactMap { $0 }
        }
        
        NXNavigationConfiguration().registerNavigationControllerClasses(classes) { navigationController, configuration in
            // Default dynamic colors
            let color = UIColor.customColor { .black } darkModeColor: { .white }
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
            
            if #available(iOS 14.0, *) {
                navigationController.nx_applyFilterNavigationVirtualWrapperViewRuleCallback { hostingController in
//                    return configureWithCustomRule(for: hostingController)
                    return NXNavigationVirtualView.configureWithDefaultRule(for: hostingController)
                }
            } else {
                // Fallback on earlier versions
            }
            
            return configuration
        }
    }
}
