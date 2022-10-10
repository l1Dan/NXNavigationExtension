//
//  View04_LikeSystemNavigationBar.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

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

struct View04_LikeSystemNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewAdaptor {
            View04_LikeSystemNavigationBar(NavigationFeatureItem(style: .likeSystemNavigationBar))
        }
    }
}
