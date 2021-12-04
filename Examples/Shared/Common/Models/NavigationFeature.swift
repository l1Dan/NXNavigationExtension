//
//  NavigationFeature.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

class NavigationFeatureItem {
    
    enum Style: String {
        case backgroundColor
        case backgroundImage
        case transparent
        case likeSystemNavigationBar
        case shadowColor
        case shadowImage
        case customBackImage
        case customBackView
        case fullScreenColor
        case present
        case tableViewController // UIKit only
        case tableViewControllerWithFullScreen // UIKit only
        case customBlurNavigationBar // UIKit only
        case listView// SwiftUI only
        case scrollViewContent // SwiftUI only
        
        case edgePopGestureDisable
        case fullScreenPopGestureEnable
        case backButtonEventIntercept
        case customNavigationBar
        case navigationBarDisable
        case webView
        case updateNavigationBar
        case redirectViewController // UIKit only
        case scrollChangeNavigationBar // UIKit only
        case customViewControllerTransitionAnimation // UIKit only
        case navigationRouter // SwiftUI only
    }
    
    let style: Style
    
    var title: String {
        return self.style.rawValue
    }
    
    var showsDisclosureIndicator: Bool {
        return true
    }
    
    init(style: Style) {
        self.style = style
    }
    
}

class NavigationFeatureSection {
    
    enum Style: String {
        case basic
        case advanced
    }
    
    let style: Style
    let items: [NavigationFeatureItem]
    
    var title: String {
        return self.style.rawValue
    }
    
    init(style: Style, items: [NavigationFeatureItem]) {
        self.style = style
        self.items = items
    }
    
    static func sections(for uikit: Bool) -> [NavigationFeatureSection] {
        var basicItems = [
            NavigationFeatureItem(style: .backgroundColor),
            NavigationFeatureItem(style: .backgroundImage),
            NavigationFeatureItem(style: .transparent),
            NavigationFeatureItem(style: .likeSystemNavigationBar),
            NavigationFeatureItem(style: .shadowColor),
            NavigationFeatureItem(style: .shadowImage),
            NavigationFeatureItem(style: .customBackImage),
            NavigationFeatureItem(style: .customBackView),
            NavigationFeatureItem(style: .fullScreenColor),
            NavigationFeatureItem(style: .present),
        ]
        
        if uikit {
            basicItems.append(NavigationFeatureItem(style: .tableViewController))
            basicItems.append(NavigationFeatureItem(style: .tableViewControllerWithFullScreen))
            basicItems.append(NavigationFeatureItem(style: .customBlurNavigationBar))
        } else {
            basicItems.append(NavigationFeatureItem(style: .listView))
            basicItems.append(NavigationFeatureItem(style: .scrollViewContent))
        }
        let basicSection = NavigationFeatureSection(style: .basic, items: basicItems)
        
        var advancedItems = [
            NavigationFeatureItem(style: .edgePopGestureDisable),
            NavigationFeatureItem(style: .fullScreenPopGestureEnable),
            NavigationFeatureItem(style: .backButtonEventIntercept),
            NavigationFeatureItem(style: .customNavigationBar),
            NavigationFeatureItem(style: .navigationBarDisable),
            NavigationFeatureItem(style: .webView),
            NavigationFeatureItem(style: .updateNavigationBar),
        ]
        
        if uikit {
            advancedItems.append(NavigationFeatureItem(style: .redirectViewController))
            advancedItems.append(NavigationFeatureItem(style: .scrollChangeNavigationBar))
            advancedItems.append(NavigationFeatureItem(style: .customViewControllerTransitionAnimation))
        } else {
            advancedItems.append(NavigationFeatureItem(style: .navigationRouter))
        }
        let advancedSection = NavigationFeatureSection(style: .advanced, items: advancedItems)
        
        return [basicSection, advancedSection]
    }
    
}
