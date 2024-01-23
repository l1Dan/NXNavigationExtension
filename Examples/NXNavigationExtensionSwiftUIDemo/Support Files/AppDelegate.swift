//
//  AppDelegate.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/11/12.
//

import UIKit
import SwiftUI
import NXNavigationExtension
import NXNavigationExtensionSwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupConfiguration()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplitAdaptiveViewController(nibName: nil, bundle: nil)
        window?.makeKeyAndVisible()
        return true
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
            
            navigationController.nx_applyFilterNavigationVirtualWrapperViewRuleCallback { hostingController in
//                return configureWithCustomRule(for: hostingController)
                return NXNavigationVirtualView.configureWithDefaultRule(for: hostingController)
            }
            
            return configuration
        }
    }
}

