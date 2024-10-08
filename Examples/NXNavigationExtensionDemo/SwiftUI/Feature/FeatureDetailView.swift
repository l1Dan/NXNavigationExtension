//
//  FeatureDetailView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

@available(iOS 14.0, *)
struct FeatureDetailView: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        switch item.style {
            // Basic
        case .backgroundColor:
            return AnyView(View01_BackgroundColor(item))
        case .backgroundImage:
            return AnyView(View02_BackgroundImage(item))
        case .transparent:
            return AnyView(View03_Transparent(item))
        case .likeSystemNavigationBar:
            return AnyView(View04_LikeSystemNavigationBar(item))
        case .shadowColor:
            return AnyView(View05_ShadowColor(item))
        case .shadowImage:
            return AnyView(View06_ShadowImage(item))
        case .customBackImage:
            return AnyView(View07_CustomBackImage(item))
        case .customBackView:
            return AnyView(View08_CustomBackView(item))
        case .fullScreenColor:
            return AnyView(View09_FullScreenColor(item))
        case .listView:
            return AnyView(View11_ListView(item))
        case .scrollViewContent:
            return AnyView(View12_ScrollViewContent(item))
            
            // Advanced
        case .edgePopGestureDisable:
            return AnyView(View01_EdgePopGestureDisable(item))
        case .fullScreenPopGestureEnable:
            return AnyView(View02_FullScreenPopGestureEnable(item))
        case .backButtonEventIntercept:
            return AnyView(View03_BackButtonEventIntercept(item))
        case .customNavigationBar:
            return AnyView(View04_CustomNavigationBar(item))
        case .navigationBarDisable:
            return AnyView(View05_NavigationBarDisable(item))
        case .webView:
            return AnyView(View06_WebView(item))
        case .updateNavigationBar:
            return AnyView(View07_UpdateNavigationBar(item))
        case .navigationRouter:
            return AnyView(View08_NavigationRouter(item))
        default:
            return AnyView(Text("No implementation").navigationBarTitle(item.title))
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        FeatureDetailView(NavigationFeatureItem(style: .scrollViewContent))
    }
}
