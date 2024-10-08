//
//  View12_ScrollViewContent.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

@available(iOS 14.0, *)
struct View12_ScrollViewContent: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorScrollView()
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle(LocalizedStringKey(item.title))
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

@available(iOS 14.0, *)
#Preview {
    NavigationView{
        View12_ScrollViewContent(NavigationFeatureItem(style: .scrollViewContent))
    }
}
