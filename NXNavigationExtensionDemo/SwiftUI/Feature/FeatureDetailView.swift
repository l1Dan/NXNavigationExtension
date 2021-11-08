//
//  FeatureDetailView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct FeatureDetailView: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        switch item.style {
            // Basic
        case .backgroundColor:
            return AnyView(BackgroundColor(item))
        case .backgroundImage:
            return AnyView(BackgrounddImage(item))
        case .transparent:
            return AnyView(Transparent(item))
        case .likeSystemNavigationBar:
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
        case .navigationBarDisable:
            return AnyView(NavigationBarUserInteractionDisable(item))
        case .backButtonEventIntercept:
            return AnyView(BackButtonEventIntercept(item))
        case .navigationRouter:
            return AnyView(NavigationRouter(item))
        case .customNavigationBar:
            return AnyView(CustomNavigationBar(item))
        case .webView:
            return AnyView(WebView(item))
        case .updateNavigationBar:
            return AnyView(UpdateNavigationBar(item))
            
        default:
            return AnyView(Text("No implementation").navigationBarTitle(item.title))
        }
    }
}

@available(iOS 13.0, *)
struct FeatureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeatureDetailView(NavigationFeatureItem(style: .scrollViewContent))
        }
    }
}
