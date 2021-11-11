//
//  View03_Transparent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct View03_Transparent: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
            }
    }
}

@available(iOS 13.0, *)
struct View03_Transparent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View03_Transparent(NavigationFeatureItem(style: .transparent))
        }
    }
}
