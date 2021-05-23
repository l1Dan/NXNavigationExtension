//
//  Models.swift
//  NXNavigationExtensionSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import Foundation

class EventInterceptItem {
    
    enum ItemType: String {
        case both = "拦截手势滑动&点击返回按钮事件"
        case popGesture = "拦截手势滑动事件"
        case backButton = "拦截返回按钮事件"
    }
    
    let itemType: ItemType
    var isSelected: Bool = false
    
    init(itemType: ItemType, isSelected: Bool = false) {
        self.itemType = itemType
        self.isSelected = isSelected
    }
    
    static func makeAllItems() -> [EventInterceptItem] {
        return [EventInterceptItem(itemType: .both, isSelected: true), EventInterceptItem(itemType: .popGesture), EventInterceptItem(itemType: .backButton)]
    }
    
}

class RedirectControllerItem {
    
    enum ItemType {
        case test1, test2, test3, test4, test5, choose, jump
    }
    
    let title: String
    let itemType: ItemType
    var isClickEnabled: Bool = true
    
    init(title: String, itemType: ItemType, isClickEnabled: Bool = true) {
        self.title = title
        self.itemType = itemType
        self.isClickEnabled = isClickEnabled
    }
    
}

struct TableViewSectionItem {
    
    enum ItemType: String {
        case navigationBarBackgroundColor = "修改导航栏背景颜色"
        case navigationBarBackgroundImage = "修改导航栏背景图片"
        case navigationBarTransparent = "设置导航栏透明"
        case navigationBarTranslucent = "设置导航栏半透明"
        case navigationBarShadowColor = "设置导航栏底部线条颜色"
        case navigationBarShadowImage = "设置导航栏底部线条图片"
        case navigationBarCustomBackButtonImage = "自定义返回按钮图片"
        case navigationBarCustomBackButton = "自定义返回按钮"
        case navigationBarFullScreen = "全屏背景色"
        case navigationBarScrollView = "UIScrollView with NXNavigationBar"
        case navigationBarScrollViewWithFullScreen = "UIScrollView 全屏背景色"
        case navigationBarModal = "模态窗口"
        case navigationBarBlur = "自定义导航栏模糊背景"

        case navigationBarDisablePopGesture = "禁用边缘手势滑动返回"
        case navigationBarFullPopGesture = "启用全屏手势滑动返回"
        case navigationBarBackEventIntercept = "导航栏返回事件拦截"
        case navigationBarRedirectViewController = "重定向任一视图控制器跳转"
        case navigationBarCustom = "完全自定义导航栏"
        case navigationBarClickEventHitToBack = "导航栏点击事件穿透到底部视图"
        case navigationBarScrollChangeNavigationBar = "滑动改变导航栏样式"
        case navigationBarWebView = "WKWebView with NXNavigationBar"
        case navigationBarUpdateNavigationBar = "更新导航栏样式"
    }
    
    let itemType: ItemType
    let showDisclosureIndicator: Bool
    
    init(itemType: ItemType, showDisclosureIndicator: Bool = true) {
        self.itemType = itemType
        self.showDisclosureIndicator = showDisclosureIndicator
    }
    
}

struct TableViewSection {

    let title: String
    let items: [TableViewSectionItem]
    
    init(title: String, items: [TableViewSectionItem]) {
        self.title = title
        self.items = items
    }
    
    static func makeAllSections() -> [TableViewSection] {
        let items1 = [
            TableViewSectionItem(itemType: .navigationBarBackgroundColor),
            TableViewSectionItem(itemType: .navigationBarBackgroundImage),
            TableViewSectionItem(itemType: .navigationBarTransparent),
            TableViewSectionItem(itemType: .navigationBarTranslucent),
            TableViewSectionItem(itemType: .navigationBarShadowColor),
            TableViewSectionItem(itemType: .navigationBarShadowImage),
            TableViewSectionItem(itemType: .navigationBarCustomBackButtonImage),
            TableViewSectionItem(itemType: .navigationBarCustomBackButton),
            TableViewSectionItem(itemType: .navigationBarFullScreen),
            TableViewSectionItem(itemType: .navigationBarScrollView),
            TableViewSectionItem(itemType: .navigationBarScrollViewWithFullScreen),
            TableViewSectionItem(itemType: .navigationBarModal, showDisclosureIndicator: false),
            TableViewSectionItem(itemType: .navigationBarBlur),
        ]
        
        let items2 = [
            TableViewSectionItem(itemType: .navigationBarDisablePopGesture),
            TableViewSectionItem(itemType: .navigationBarFullPopGesture),
            TableViewSectionItem(itemType: .navigationBarBackEventIntercept),
            TableViewSectionItem(itemType: .navigationBarRedirectViewController),
            TableViewSectionItem(itemType: .navigationBarCustom),
            TableViewSectionItem(itemType: .navigationBarClickEventHitToBack),
            TableViewSectionItem(itemType: .navigationBarScrollChangeNavigationBar),
            TableViewSectionItem(itemType: .navigationBarWebView),
            TableViewSectionItem(itemType: .navigationBarUpdateNavigationBar),
        ]
        
        return [TableViewSection(title: "基础功能", items: items1), TableViewSection(title: "高级功能", items: items2)]
    }
}
