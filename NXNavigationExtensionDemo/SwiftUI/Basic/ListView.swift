//
//  ListView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct ListView: View {
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

@available(iOS 13.0.0, *)
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView(NavigationFeatureItem(style: .listView))            
        }
    }
}
