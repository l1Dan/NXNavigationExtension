//
//  BackgrounddImage.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct BackgrounddImage: View {
    @State private var isPresented = false
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView(onPrepareConfiguration: { configuration in
                configuration.navigationBarAppearance.backgroundImage = UIImage(named: "NavigationBarBackground88")
                configuration.navigationBarAppearance.tintColor = .white
                configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            })
    }
}

@available(iOS 13, *)
struct BackgrounddImage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BackgrounddImage(NavigationFeatureItem(style: .backgroundImage))
        }
    }
}
