//
//  View07_CustomBackImage.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/20.
//

import SwiftUI

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

struct View07_CustomBackImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View07_CustomBackImage(NavigationFeatureItem(style: .customBackImage))
        }
    }
}
