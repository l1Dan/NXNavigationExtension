//
//  View04_LikeSystemNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

@available(iOS 14.0, *)
struct View04_LikeSystemNavigationBar: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView(onPrepareConfiguration:  { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true
            })
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View04_LikeSystemNavigationBar(NavigationFeatureItem(style: .likeSystemNavigationBar))
    }
}
