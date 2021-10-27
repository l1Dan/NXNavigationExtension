//
//  ShadowColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct ShadowColor: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(Text(item.title), displayMode: .inline)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundColor = .systemBackground
                configuration.navigationBarAppearance.shadowColor = .systemRed
            })
    }
}

@available(iOS 13, *)
struct ShadowColor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShadowColor(NavigationFeatureItem(style: .shadowColor))
        }
    }
}
