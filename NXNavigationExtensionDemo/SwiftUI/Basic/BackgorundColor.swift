//
//  BackgorundColor.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct BackgorundColor: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
                let tintColor = userInterfaceStyle == .dark ? UIColor.white : UIColor.black
                configuration.navigationBarAppearance.tintColor = tintColor
                configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? .systemBlue : .systemRed

                // Dynamic color
                let color = UIColor.customColor { return .black } darkModeColor: { return .white }
                if let traitCollection = configuration.viewControllerPreferences.traitCollection {
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color.resolvedColor(with: traitCollection)]
                } else {
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
                }

                return configuration
            }
    }
}

@available(iOS 13.0.0, *)
struct BackgorundColor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BackgorundColor(NavigationFeatureItem(style: .backgorundColor))
        }
    }
}
