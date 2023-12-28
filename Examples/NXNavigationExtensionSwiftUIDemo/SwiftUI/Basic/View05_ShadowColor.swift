//
//  View05_ShadowColor.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

struct View05_ShadowColor: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(LocalizedStringKey(item.title), displayMode: .inline)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .systemBackground
                configuration.navigationBarAppearance.shadowColor = .systemRed
            })
    }
}

#Preview {
    AdaptiveNavigationView {
        View05_ShadowColor(NavigationFeatureItem(style: .shadowColor))
    }
}
