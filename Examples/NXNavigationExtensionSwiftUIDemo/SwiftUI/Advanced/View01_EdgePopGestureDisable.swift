//
//  View01_EdgePopGestureDisable.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

struct View01_EdgePopGestureDisable: View {
    private let randomDark = UIColor.randomDark
    private let randomLight = UIColor.randomLight
    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
                configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? randomDark : randomLight
            }, onBackActionHandler: { action in
                if case .interactionGesture = action {
                    return false
                }
                return true
            })
    }
}

#Preview {
    AdaptiveNavigationView {
        View01_EdgePopGestureDisable(NavigationFeatureItem(style: .edgePopGestureDisable))
    }
}
