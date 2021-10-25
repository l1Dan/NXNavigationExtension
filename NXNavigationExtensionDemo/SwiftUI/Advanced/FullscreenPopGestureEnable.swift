//
//  FullscreenPopGestureEnable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct FullscreenPopGestureEnable: View {
    private let randomDark = UIColor.randomDark
    private let randomLight = UIColor.randomLight
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
        .navigationBarTitle(item.title)
        .useNXNavigationView(onPrepareConfiguration: { configuration in
            let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
            configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? randomDark : randomLight
            configuration.viewControllerPreferences.enableFullscreenInteractivePopGesture = true
        })
    }
}

@available(iOS 13, *)
struct FullscreenPopGestureEnable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FullscreenPopGestureEnable(NavigationFeatureItem(style: .fullscreenPopGestureEnable))            
        }
    }
}
