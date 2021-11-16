//
//  NavigationRedirect.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import Foundation

class NavigationRedirect {
    
    enum Style {
        case test1, test2, test3, test4, test5, choose, jump
    }
    
    let title: String
    let style: NavigationRedirect.Style
    var isSelectEnable: Bool
    
    init(title: String, style: NavigationRedirect.Style) {
        self.title = title
        self.style = style
        self.isSelectEnable = true
    }
    
    static var items: [NavigationRedirect] {
        return [
            NavigationRedirect(title: NSStringFromClass(ViewController01_Test.self), style: .test1),
            NavigationRedirect(title: NSStringFromClass(ViewController02_Test.self), style: .test2),
            NavigationRedirect(title: NSStringFromClass(ViewController03_Test.self), style: .test3),
            NavigationRedirect(title: NSStringFromClass(ViewController04_Test.self), style: .test4),
            NavigationRedirect(title: NSStringFromClass(ViewController05_Test.self), style: .test5),
            NavigationRedirect(title: NSLocalizedString("selectViewControllerClass", comment: ""), style: .choose),
            NavigationRedirect(title: NSLocalizedString("redirectTo", comment: ""), style: .jump),
        ]
    }
    
}
