//
//  View05_ShadowColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

@available(iOS 14.0, *)
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

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View05_ShadowColor(NavigationFeatureItem(style: .shadowColor))
    }
}
