//
//  View04_LikeSystemNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct View04_LikeSystemNavigationBar: View {
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
struct View04_LikeSystemNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View04_LikeSystemNavigationBar(NavigationFeatureItem(style: .likeSystemNavigationBar))
        }
    }
}
