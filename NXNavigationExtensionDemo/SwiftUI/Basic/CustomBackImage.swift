//
//  CustomBackImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/20.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)

@available(iOS 13, *)
struct CustomBackImage: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backImage = UIImage(systemName: "arrow.left")
            }
        
    }
}

@available(iOS 13, *)
struct CustomBackImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomBackImage(NavigationFeatureItem(style: .customBackImage))
        }
    }
}
