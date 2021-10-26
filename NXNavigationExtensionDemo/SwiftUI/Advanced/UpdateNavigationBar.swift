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
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var context: NXNavigationContext?
    @State private var title = "Custom"
    @State private var count = 0

    @State private var darkColor = UIColor.randomDark
    @State private var lightColor = UIColor.randomLight
    @State private var isLightTheme = true

    private static let buttonWidthAndHeight = 160.0
    
    private let item: NavigationFeatureItem
    
    private var randomColor: UIColor {
        switch colorScheme {
        case .dark: return darkColor
        default: return lightColor
        }
    }
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            count += 1
            title = "😜(\(count))"
            isLightTheme.toggle()
            
            switch colorScheme {
            case .dark: darkColor = UIColor.randomDark
            default: lightColor = UIColor.randomLight
            }
            
            if let context = context {
                NXNavigationRouter.of(context).setNeedsNavigationBarAppearanceUpdate()
            }
        } label: {
            Text("Update")
                .foregroundColor(Color(randomColor))
                .frame(width: UpdateNavigationBar.buttonWidthAndHeight, height: UpdateNavigationBar.buttonWidthAndHeight)
        }
        .overlay(RoundedRectangle(cornerRadius: UpdateNavigationBar.buttonWidthAndHeight * 0.5, style: .circular).strokeBorder(Color(randomColor), lineWidth: 5))
        .navigationBarTitle(item.title)
        .useNXNavigationView(onPrepareConfiguration: { configuration in
            configuration.navigationBarAppearance.useSystemBackButton = true
            configuration.navigationBarAppearance.tintColor = isLightTheme ? .black : .white
            configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
            configuration.navigationBarAppearance.systemBackButtonTitle = title
            configuration.navigationBarAppearance.backgroundColor = randomColor
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
