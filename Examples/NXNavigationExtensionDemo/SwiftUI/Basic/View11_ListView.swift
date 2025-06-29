//
//  View11_ListView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

@available(iOS 14.0, *)
struct View11_ListView: View {
    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
            }
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View11_ListView(NavigationFeatureItem(style: .listView))
    }
}
