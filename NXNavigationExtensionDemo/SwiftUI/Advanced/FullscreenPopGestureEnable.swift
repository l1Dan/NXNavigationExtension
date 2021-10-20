//
//  FullscreenPopGestureEnable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct FullscreenPopGestureEnable: View {
    private let item: NavigationFeatureItem
    let randomColor = UIColor.randomLight
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack {
                    Rectangle().fill(Color.red).frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top)
                    Rectangle().fill(Color.blue).frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top)
                    Rectangle().fill(Color.red).frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top)
                    Rectangle().fill(Color.yellow).frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top)
                    Rectangle().fill(Color.red).frame(width: geometry.size.width, height: geometry.size.height + geometry.safeAreaInsets.top)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarTitle(item.title)
        .useNXNavigationView { configuration in
            configuration.navigationBarAppearance.backgroundColor = .clear
            configuration.viewControllerPreferences.enableFullscreenInteractivePopGesture = true
        }
    }
}

@available(iOS 13, *)
struct FullscreenPopGestureEnable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FullscreenPopGestureEnable(NavigationFeatureItem(style: .fullscreenPopGestureEnable))            
        }
    }
}
