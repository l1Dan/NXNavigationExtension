//
//  NavigatioinBarUserInteractionDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct NavigatioinBarUserInteractionDisable: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorScrollView(true)
            .useNXNavigationView { configuration in
                configuration.viewControllerPreferences.enableFullscreenInteractivePopGesture = true
                configuration.viewControllerPreferences.translucentNavigationBar = true
            }
    }
}

@available(iOS 13, *)
struct NavigatioinBarUserInteractionDisable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigatioinBarUserInteractionDisable(NavigationFeatureItem(style: .navigatioinBarUserInteractionDisable))
        }
    }
}
