//
//  View10_Present.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/17.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

struct View10_Present: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var presentedAsModal: Bool
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem, presentedAsModal: Binding<Bool>) {
        self.item = item
        self._presentedAsModal = presentedAsModal
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .navigationBarItems(leading:Button (action: {
                self.presentedAsModal = false
            }, label: {
                Image(systemName: "xmark")
            }).foregroundColor(colorScheme == .dark ? Color.white : Color.black))
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true
            })
    }
}

#Preview {
    AdaptiveNavigationView {
        @State var presentedAsModal = false
        View10_Present(NavigationFeatureItem(style: .present), presentedAsModal: $presentedAsModal)
    }
}

