//
//  View07_CustomBackImage.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/20.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

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

#Preview {
    AdaptiveNavigationView {
        View07_CustomBackImage(NavigationFeatureItem(style: .customBackImage))
    }
}
