//
//  FeatureDetailView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct FeatureDetailView: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        switch item.style {
            // Basic
        case .backgorundColor:
            return AnyView(BackgorundColor(item))
        case .backgorundImage:
            return AnyView(BackgorundImage(item))
        case .transparent:
            return AnyView(Transparent(item))
        case .blurNavigationBarLikeSystem:
            return AnyView(BlurNavigationBarLikeSystem(item))
        case .shadowColor:
            return AnyView(ShadowColor(item))
        case .shadowImage:
            return AnyView(ShadowImage(item))
        case .customBackImage:
            return AnyView(CustomBackImage(item))
        case .customBackView:
            return AnyView(CustomBackView(item))
        case .fullScreenColor:
            return AnyView(FullScreenColor(item))
        case .listView:
            return AnyView(ListView(item))
        case .scrollViewContent:
            return AnyView(ScrollViewContent(item))
            
            // Advanced
        case .edgePopGestureDisable:
            return AnyView(EdgePopGestureDisable(item))
        case .fullScreenPopGestureEnable:
            return AnyView(FullScreenPopGestureEnable(item))
        case .navigatioinBarUserInteractionDisable:
            return AnyView(NavigatioinBarUserInteractionDisable(item))
        case .backButtonEventIntercept:
            return AnyView(BackButtonEventIntercept(item))
        case .customNavigationBar:
            return AnyView(CustomNavigationBar(item))
        case .webView:
            return AnyView(WebView(item))
        case .updateNavigationBarForManually:
            return AnyView(UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBarForManually)))
            
        default:
            return AnyView(Text("No implementation").navigationBarTitle(item.title))
        }
    }
}

@available(iOS 13, *)
struct FeatureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeatureDetailView(NavigationFeatureItem(style: .scrollViewContent))
        }
    }
}
