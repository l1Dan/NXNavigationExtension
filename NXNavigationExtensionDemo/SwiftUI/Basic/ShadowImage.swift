//
//  ShadowImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct ShadowImage: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(item.title)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .systemBackground
                configuration.navigationBarAppearance.shadowImage = UIImage(named: "NavigationBarShadowImage")
            })
    }
}

@available(iOS 13, *)
struct ShadowImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShadowImage(NavigationFeatureItem(style: .shadowImage))
        }
    }
}
