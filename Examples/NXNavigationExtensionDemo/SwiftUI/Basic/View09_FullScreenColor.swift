//
//  View09_FullScreenColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

struct View09_FullScreenColor: View {

    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        colorView
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
            }
    }

    private var colorView: some View {
        return AnyView(Color(UIColor.randomLight).ignoresSafeArea())
    }
}

#Preview {
    AdaptiveNavigationView {
        View09_FullScreenColor(NavigationFeatureItem(style: .fullScreenColor))
    }
}
