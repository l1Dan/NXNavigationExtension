//
//  NavigationFeature.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

class NavigationFeatureItem {
    
    enum Style: String {
        case backgroundColor = "修改导航栏背景颜色"
        case backgroundImage = "修改导航栏背景图片"
        case transparent = "设置导航栏透明"
        case likeSystemNavigationBar = "实现系统导航栏模糊效果"
        case shadowColor = "设置导航栏底部线条颜色"
        case shadowImage = "设置导航栏底部线条图片"
        case customBackImage = "自定义返回按钮图片"
        case customBackView = "自定义返回按钮"
        case fullScreenColor = "全屏背景色"
        case present = "Present"
        case tableViewController = "UITableViewController" // UIKit only
        case tableViewControllerWithFullScren = "UITableViewController 全屏背景色" // UIKit only
        case customBlurNavigationBar = "自定义导航栏模糊背景" // UIKit only
        case listView = "List" // SwiftUI only
        case scrollViewContent = "ScrollView" // SwiftUI only
        
        case edgePopGestureDisable = "禁用边缘手势滑动返回"
        case fullScreenPopGestureEnable = "启用全屏手势滑动返回"
        case backButtonEventIntercept = "导航栏返回事件拦截"
        case customNavigationBar = "完全自定义导航栏"
        case navigationBarDisable = "导航栏点击事件穿透到底部视图"
        case webView = "WKWebView"
        case updateNavigationBar = "更新导航栏样式"
        case redirectViewController = "重定向任一视图控制器跳转" // UIKit only
        case scrollChangeNavigationBar = "滑动改变导航栏样式" // UIKit only
        case customViewControllerTransitionAnimation = "自定义转场动画" // UIKit only
        case navigationRouter = "SwiftUI 路由管理" // SwiftUI only
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
        case basic = "基础功能"
        case advanced = "高级功能"
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
            basicItems.append(NavigationFeatureItem(style: .tableViewControllerWithFullScren))
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
