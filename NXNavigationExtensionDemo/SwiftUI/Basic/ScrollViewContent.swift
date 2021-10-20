//
//  ScrollViewContent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct ScrollViewContent: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorScrollView()
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle(item.title)
        .useNXNavigationView { configuration in
            configuration.navigationBarAppearance.backgroundColor = .clear
        }
    }
    
    private var listView: some View {
        if #available(iOS 14.0, *) {
            return AnyView(ColorListView().ignoresSafeArea())
        } else {
            return AnyView(ColorListView().edgesIgnoringSafeArea(.all))
        }
    }
}

@available(iOS 13, *)
struct ScrollViewContent_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ScrollViewContent(NavigationFeatureItem(style: .scrollViewContent))
        }
    }
}
