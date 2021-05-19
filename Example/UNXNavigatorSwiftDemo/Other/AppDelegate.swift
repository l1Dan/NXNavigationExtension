//
//  AppDelegate.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import ObjectiveC

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .customBackground
        window?.rootViewController = MainSplitViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

