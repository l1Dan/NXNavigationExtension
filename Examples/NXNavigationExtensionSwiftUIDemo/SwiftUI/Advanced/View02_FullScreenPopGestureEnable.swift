//
//  View02_FullScreenPopGestureEnable.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

struct View02_FullScreenPopGestureEnable: View {
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
            configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture = true
        })
    }
}

struct View02_FullScreenPopGestureEnable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewAdaptor {
            View02_FullScreenPopGestureEnable(NavigationFeatureItem(style: .fullScreenPopGestureEnable))            
        }
    }
}
