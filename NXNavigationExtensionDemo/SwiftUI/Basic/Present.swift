//
//  Present.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct Present: View {
    @Binding var presentedAsModal: Bool
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem, presentedAsModal: Binding<Bool>) {
        self.item = item
        self._presentedAsModal = presentedAsModal
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .navigationBarItems(leading: Button (action: {
                self.presentedAsModal = false
            }, label: {
                Image(systemName: "xmark")
            }))
            .useNXNavigationView { configuration in
                let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
                let tintColor = userInterfaceStyle == .dark ? UIColor.white : UIColor.black
                configuration.navigationBarAppearance.tintColor = tintColor
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true

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
struct Present_Previews: PreviewProvider {
    @State static var presentedAsModal = false
    static var previews: some View {
        NavigationView {
            Present(NavigationFeatureItem(style: .present), presentedAsModal: $presentedAsModal)
        }
    }
}
