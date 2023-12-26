//
//  View07_UpdateNavigationBar.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/18.
//

import SwiftUI
import NXNavigationExtension

struct View07_UpdateNavigationBar: View {
    @State private var context: NXNavigationRouter.Context
    @State private var title = "Custom"
    @State private var count = 0

    @State private var darkColor = UIColor.randomDark
    @State private var lightColor = UIColor.randomLight
    @State private var isLightTheme = true

    private static let buttonWidthAndHeight = 160.0
    
    private let item: NavigationFeatureItem
    
    private var randomColor: UIColor {
        if isLightTheme {
            return lightColor
        } else {
            return darkColor
        }
    }
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
        self.context = NXNavigationRouter.Context(routeName: "/UpdateNavigationBar")
    }
    
    var body: some View {
        Button {
            count += 1
            title = "😜(\(count))"
            isLightTheme.toggle()
            
            if isLightTheme {
                lightColor = UIColor.randomLight
            } else {
                darkColor = UIColor.randomDark
            }
            
            NXNavigationRouter.of(context).setNeedsNavigationBarAppearanceUpdate()
        } label: {
            Text("Update")
                .foregroundColor(Color(randomColor))
                .frame(width: View07_UpdateNavigationBar.buttonWidthAndHeight, height: View07_UpdateNavigationBar.buttonWidthAndHeight)
        }
        .overlay(RoundedRectangle(cornerRadius: View07_UpdateNavigationBar.buttonWidthAndHeight * 0.5, style: .circular).strokeBorder(Color(randomColor), lineWidth: 5))
        .navigationBarTitle(LocalizedStringKey(item.title))        
        .useNXNavigationView(context: $context, onPrepareConfiguration: { configuration in
            configuration.navigationBarAppearance.useSystemBackButton = true
            configuration.navigationBarAppearance.tintColor = isLightTheme ? .black : .white
            configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
            configuration.navigationBarAppearance.systemBackButtonTitle = title
            configuration.navigationBarAppearance.backgroundColor = randomColor
        })
    }
    
}

struct View07_UpdateNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        AdaptiveNavigationView {
            View07_UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBar))
        }
    }
}
