//
//  View03_Transparent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

@available(iOS 14.0, *)
struct View03_Transparent: View {
    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.navigationBarAppearance.shadowColor = .clear
            })
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View03_Transparent(NavigationFeatureItem(style: .transparent))
    }
}
