//
//  View10_Present.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

@available(iOS 14.0, *)
struct View10_Present: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var presentedAsModal: Bool

    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem, presentedAsModal: Binding<Bool>) {
        self.item = item
        _presentedAsModal = presentedAsModal
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .navigationBarItems(leading: Button(action: {
                presentedAsModal = false
            }, label: {
                Image(systemName: "xmark")
            }).foregroundColor(colorScheme == .dark ? Color.white : Color.black))
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true
            })
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var presentedAsModal = false
    AdaptiveNavigationView {
        View10_Present(NavigationFeatureItem(style: .present), presentedAsModal: $presentedAsModal)
    }
}
