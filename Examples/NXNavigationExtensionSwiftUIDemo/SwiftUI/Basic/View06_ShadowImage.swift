//
//  View06_ShadowImage.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

struct View06_ShadowImage: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(LocalizedStringKey(item.title), displayMode: .inline)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .systemBackground
                configuration.navigationBarAppearance.shadowImage = UIImage(named: "NavigationBarShadowImage")
            })
    }
}

struct View06_ShadowImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View06_ShadowImage(NavigationFeatureItem(style: .shadowImage))
        }
    }
}
