//
//  View05_ShadowColor.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

struct View05_ShadowColor: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(Text(item.title), displayMode: .inline)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .systemBackground
                configuration.navigationBarAppearance.shadowColor = .systemRed
            })
    }
}

struct View05_ShadowColor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View05_ShadowColor(NavigationFeatureItem(style: .shadowColor))
        }
    }
}
