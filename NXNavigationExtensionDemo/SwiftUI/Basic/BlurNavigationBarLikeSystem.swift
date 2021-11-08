//
//  BlurNavigationBarLikeSystem.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct BlurNavigationBarLikeSystem: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView(onPrepareConfiguration:  { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true
            })
    }
}

@available(iOS 13.0, *)
struct BlurNavigationBarLikeSystem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BlurNavigationBarLikeSystem(NavigationFeatureItem(style: .likeSystemNavigationBar))
        }
    }
}
