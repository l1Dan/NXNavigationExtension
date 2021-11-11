//
//  View09_FullScreenColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct View09_FullScreenColor: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        colorView
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in                
                configuration.navigationBarAppearance.backgroundColor = .clear
            }
    }
    
    private var colorView: some View {
        if #available(iOS 14.0, *) {
            return AnyView(Color(UIColor.randomLight).ignoresSafeArea())
        } else {
            return AnyView(Color(UIColor.randomLight).edgesIgnoringSafeArea(.all))
        }
    }
}

@available(iOS 13.0, *)
struct View09_FullScreenColor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View09_FullScreenColor(NavigationFeatureItem(style: .fullScreenColor))
        }
    }
}
