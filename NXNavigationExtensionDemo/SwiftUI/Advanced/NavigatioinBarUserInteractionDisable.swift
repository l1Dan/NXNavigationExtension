//
//  NavigatioinBarUserInteractionDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct NavigatioinBarUserInteractionDisable: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ColorScrollView(true)
                    .useNXNavigationView(onPrepareConfiguration: { configuration in
                        configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture = true
                        configuration.viewControllerPreferences.translucentNavigationBar = true
                    })
                    .padding(.top, UIApplication.shared.statusBarHeight)
            }
            ZStack {
                Color.red
                    .opacity(0.9)
                    .frame(width: geometry.size.width, height: UIApplication.shared.statusBarHeight)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

@available(iOS 13, *)
struct NavigatioinBarUserInteractionDisable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigatioinBarUserInteractionDisable(NavigationFeatureItem(style: .navigatioinBarUserInteractionDisable))
        }
    }
}
