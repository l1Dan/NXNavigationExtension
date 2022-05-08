//
//  NavigationJump.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/9.
//

import Foundation

class NavigationJump {
    
    enum Style {
        case test1, test2, test3, test4, test5, choose, jump
    }
    
    let title: String
    let style: NavigationJump.Style
    var isSelectEnable: Bool
    
    init(title: String, style: NavigationJump.Style) {
        self.title = title
        self.style = style
        self.isSelectEnable = true
    }
    
    static var items: [NavigationJump] {
        return [
            NavigationJump(title: NSStringFromClass(VC01_Test.self), style: .test1),
            NavigationJump(title: NSStringFromClass(VC02_Test.self), style: .test2),
            NavigationJump(title: NSStringFromClass(VC03_Test.self), style: .test3),
            NavigationJump(title: NSStringFromClass(VC04_Test.self), style: .test4),
            NavigationJump(title: NSStringFromClass(VC05_Test.self), style: .test5),
            NavigationJump(title: NSLocalizedString("selectViewControllerClass", comment: ""), style: .choose),
            NavigationJump(title: NSLocalizedString("jumpTo", comment: ""), style: .jump),
        ]
    }
    
}
