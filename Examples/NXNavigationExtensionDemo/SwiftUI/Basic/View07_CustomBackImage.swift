//
//  View07_CustomBackImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/20.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

@available(iOS 14.0, *)
struct View07_CustomBackImage: View {
    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backImage = UIImage(systemName: "arrow.left")
            }
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        View07_CustomBackImage(NavigationFeatureItem(style: .customBackImage))
    }
}
