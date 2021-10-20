//
//  EdgePopGestureDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct EdgePopGestureDisable: View {
    private let item: NavigationFeatureItem
    let randomColor = UIColor.randomLight
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        Text(item.title)
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = randomColor
                configuration.navigationBarAppearance.tintColor = .black
                configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                configuration.viewControllerPreferences.disableInteractivePopGesture = true
            }
    }
}

@available(iOS 13.0.0, *)
struct EdgePopGestureDisable_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EdgePopGestureDisable(NavigationFeatureItem(style: .edgePopGestureDisable))
        }
    }
}
