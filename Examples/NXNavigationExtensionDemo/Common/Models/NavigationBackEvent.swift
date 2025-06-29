//
//  NavigationBackEvent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import Foundation

class NavigationBackEvent {
    enum State: String {
        case all, clickBackButton, clickBackButtonMenu, interactionGesture, callingNXPopMethod
    }

    let state: NavigationBackEvent.State

    var isSelected: Bool = false

    var title: String {
        return state.rawValue
    }

    init(state: NavigationBackEvent.State, isSelected: Bool = false) {
        self.state = state
        self.isSelected = isSelected
    }

    static var items: [NavigationBackEvent] {
        return [
            NavigationBackEvent(state: .all, isSelected: true),
            NavigationBackEvent(state: .clickBackButton),
            NavigationBackEvent(state: .clickBackButtonMenu),
            NavigationBackEvent(state: .interactionGesture),
            NavigationBackEvent(state: .callingNXPopMethod),
        ]
    }
}
