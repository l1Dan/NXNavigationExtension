//
//  NavigationBackEvent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

class NavigationBackEvent {
    
    enum State: String {
        case all = "拦截所有返回页面途径"
        case backButtonAction = "拦截返回按钮点击事件"
        case backButtonMenuAction = "拦截返回按钮长按选择事件"
        case popGestureRecognizer = "拦截手势滑动返回事件"
        case callNXPopMethod = "拦截调用 nx_pop 方法返回事件"
    }
    
    let state: NavigationBackEvent.State
    
    var isSelected: Bool = false
    
    var title: String {
        return self.state.rawValue
    }
    
    init(state: NavigationBackEvent.State, isSelected: Bool = false) {
        self.state = state
        self.isSelected = isSelected
    }
    
    static var items: [NavigationBackEvent] {
        return [
            NavigationBackEvent(state: .all, isSelected: true),
            NavigationBackEvent(state: .backButtonAction),
            NavigationBackEvent(state: .backButtonMenuAction),
            NavigationBackEvent(state: .popGestureRecognizer),
            NavigationBackEvent(state: .callNXPopMethod),
        ]
    }
    
}
