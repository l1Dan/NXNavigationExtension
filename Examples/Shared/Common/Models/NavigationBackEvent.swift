//
//  NavigationBackEvent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import NXNavigationExtension

class NavigationBackEvent {
    
    enum State: String {
        case all, backButtonAction, backButtonMenuAction, popGestureRecognizer, callNXPopMethod
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


extension NavigationBackEvent {
    
    static func toNavigationActionString(_ navigationAction: NXNavigationAction) -> String {
        let prefix = "Transitioning Action: "
        switch navigationAction {
        case .unspecified: return prefix + "Unspecified"
        case .willPush: return prefix + "WillPush"
        case .didPush: return prefix + "DidPush"
        case .pushCancelled: return prefix + "PushCancelled"
        case .pushCompleted: return prefix + "PushCompleted"
        case .willPop: return prefix + "WillPop"
        case .didPop: return prefix + "DidPop"
        case .popCancelled: return prefix + "PopCancelled"
        case .popCompleted: return prefix + "PopCompleted"
        case .willSet: return prefix + "WillSet"
        case .didSet: return prefix + "DidSet"
        case .setCancelled: return prefix + "SetCancelled"
        case .setCompleted: return prefix + "SetCompleted"
        default: return prefix + "None"
        }
    }
    
}
