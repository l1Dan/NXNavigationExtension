//
//  NavigationBackEvent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import Foundation

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
