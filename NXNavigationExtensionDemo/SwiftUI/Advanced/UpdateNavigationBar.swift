//
//  UpdateNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/18.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0.0, *)
struct UpdateNavigationBar: View {
    private static let buttonWidthAndHeight = 160.0
    
    @State private var colorScheme = ColorScheme.dark
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            switch colorScheme {
            case .dark:
                colorScheme = .light
            case .light:
                colorScheme = .dark
            @unknown default:
                colorScheme = .light
            }
        } label: {
            Text("Update")
        }
        .frame(width: UpdateNavigationBar.buttonWidthAndHeight, height: UpdateNavigationBar.buttonWidthAndHeight)
        .overlay(
            RoundedRectangle(cornerRadius: UpdateNavigationBar.buttonWidthAndHeight * 0.5, style: .circular).strokeBorder(Color.blue, lineWidth: 5))
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
            }.preferredColorScheme(colorScheme)
    }
}

@available(iOS 13.0.0, *)
struct UpdateNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBarForManually))
        }
    }
}
