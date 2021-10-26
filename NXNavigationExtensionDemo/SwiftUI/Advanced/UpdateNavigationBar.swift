//
//  UpdateNavigationBar.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/18.
//

import NXNavigationExtension

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct UpdateNavigationBar: View {
    private static let buttonWidthAndHeight = 160.0
    
    @State private var context: NXNavigationContext?
    @State private var colorScheme = ColorScheme.dark
    @State private var title = "Custom"
    @State private var count = 0
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            count += 1
            title = "😜(\(count))"
            
            if let context = context {
                NXNavigationRouter.of(context).setNeedsNavigationBarAppearanceUpdate()
            }
            
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
                .frame(width: UpdateNavigationBar.buttonWidthAndHeight, height: UpdateNavigationBar.buttonWidthAndHeight)
        }
        .overlay(RoundedRectangle(cornerRadius: UpdateNavigationBar.buttonWidthAndHeight * 0.5, style: .circular).strokeBorder(Color.blue, lineWidth: 5))
        .navigationBarTitle(item.title)
        .preferredColorScheme(colorScheme)
        .useNXNavigationView(onPrepareConfiguration: { configuration in
            let userInterfaceStyle = configuration.viewControllerPreferences.traitCollection?.userInterfaceStyle ?? .light
            configuration.navigationBarAppearance.backgroundColor = userInterfaceStyle == .dark ? .systemBlue : .systemRed
            configuration.navigationBarAppearance.useSystemBackButton = true
            configuration.navigationBarAppearance.systemBackButtonTitle = title
        }, onContextChanged: { context in
            self.context = context
        })
    }
}

@available(iOS 13, *)
struct UpdateNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBarForManually))
        }
    }
}
