//
//  View02_BackgroundImage.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

struct View02_BackgroundImage: View {
    @State private var isPresented = false
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackground88")
                configuration.navigationBarAppearance.tintColor = .white
                configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            })
    }
}

struct View02_BackgroundImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewAdaptor {
            View02_BackgroundImage(NavigationFeatureItem(style: .backgroundImage))
        }
    }
}
