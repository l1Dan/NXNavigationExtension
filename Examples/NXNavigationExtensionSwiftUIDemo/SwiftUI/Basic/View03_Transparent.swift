//
//  View03_Transparent.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

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

struct View03_Transparent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View03_Transparent(NavigationFeatureItem(style: .transparent))
        }
    }
}
