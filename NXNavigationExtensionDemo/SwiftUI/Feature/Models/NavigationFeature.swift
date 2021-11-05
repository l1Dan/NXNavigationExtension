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
        case blurNavigationBarLikeSystem = "实现系统导航栏模糊效果"
        case blurNavigationBarCustom = "自定义导航栏模糊背景" // Not working
        case shadowColor = "设置导航栏底部线条颜色"
        case shadowImage = "设置导航栏底部线条图片"
        case customBackImage = "自定义返回按钮图片"
        case customBackView = "自定义返回按钮"
        case fullScreenColor = "全屏背景色"
        case listView = "List"
        case scrollViewContent = "ScrollView"
        case present = "Present ViewController"
        
        case edgePopGestureDisable = "禁用边缘手势滑动返回"
        case fullScreenPopGestureEnable = "启用全屏手势滑动返回"
        case backButtonEventIntercept = "导航栏返回事件拦截"
        case navigationRouter = "SwiftUI 路由管理"
        case customNavigationBar = "完全自定义导航栏"
        case navigationBarUserInteractionDisable = "导航栏点击事件穿透到底部视图"
        case dynamicChangeNavigationBarStyle = "滑动改变导航栏样式" // Not working
        case webView = "WKWebView"
        case updateNavigationBarForManually = "更新导航栏样式"
        case customViewControllerTransitionAnimation = "自定义转场动画" // Not working
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
    
    static var sections: [NavigationFeatureSection] {
        let basicItems = [
            NavigationFeatureItem(style: .backgroundColor),
            NavigationFeatureItem(style: .backgroundImage),
            NavigationFeatureItem(style: .transparent),
            NavigationFeatureItem(style: .blurNavigationBarLikeSystem),
//            NavigationFeatureItem(style: .blurNavigationBarCustom),
            NavigationFeatureItem(style: .shadowColor),
            NavigationFeatureItem(style: .shadowImage),
            NavigationFeatureItem(style: .customBackImage),
            NavigationFeatureItem(style: .customBackView),
            NavigationFeatureItem(style: .fullScreenColor),
            NavigationFeatureItem(style: .listView),
            NavigationFeatureItem(style: .scrollViewContent),
            NavigationFeatureItem(style: .present),
            
        ]
        let basicSection = NavigationFeatureSection(style: .basic, items: basicItems)
        
        let advancedItems = [
            NavigationFeatureItem(style: .edgePopGestureDisable),
            NavigationFeatureItem(style: .fullScreenPopGestureEnable),
            NavigationFeatureItem(style: .backButtonEventIntercept),
            NavigationFeatureItem(style: .navigationRouter),
            NavigationFeatureItem(style: .customNavigationBar),
            NavigationFeatureItem(style: .navigationBarUserInteractionDisable),
//            NavigationFeatureItem(style: .dynamicChangeNavigationBarStyle),
            NavigationFeatureItem(style: .webView),
            NavigationFeatureItem(style: .updateNavigationBarForManually),
//            NavigationFeatureItem(style: .customViewControllerTransitionAnimation),
        ]
        let advancedSection = NavigationFeatureSection(style: .advanced, items: advancedItems)
        
        return [basicSection, advancedSection]
    }
    
}
