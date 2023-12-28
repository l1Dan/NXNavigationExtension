//
//  View03_Transparent.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

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

#Preview {
    AdaptiveNavigationView {
        View03_Transparent(NavigationFeatureItem(style: .transparent))
    }
}
