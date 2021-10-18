//
//  NavigationEventItem.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

enum NavigationEventItemType: String {
    case all = "拦截所有返回页面途径"
    case backButtonAction = "拦截返回按钮点击事件"
    case backButtonMenuAction = "拦截返回按钮长按选择事件"
    case popGestureRecognizer = "拦截手势滑动返回事件"
    case callNXPopMethod = "拦截调用 nx_pop 方法返回事件"
}

class NavigationEventItem {
    let type: NavigationEventItemType
    
    var selected: Bool = false
    
    var title: String {
        return self.type.rawValue
    }
    
    init(type: NavigationEventItemType, selected: Bool = false) {
        self.type = type
        self.selected = selected
    }
    
    static var items: [NavigationEventItem] {
        return [
            NavigationEventItem(type: .all, selected: true),
            NavigationEventItem(type: .backButtonAction),
            NavigationEventItem(type: .backButtonMenuAction),
            NavigationEventItem(type: .popGestureRecognizer),
            NavigationEventItem(type: .callNXPopMethod),
        ]
    }
    
}
