//
//  View11_ListView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

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

struct View11_ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View11_ListView(NavigationFeatureItem(style: .listView))            
        }
    }
}
