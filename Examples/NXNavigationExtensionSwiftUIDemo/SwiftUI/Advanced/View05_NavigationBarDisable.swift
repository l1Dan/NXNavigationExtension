//
//  View05_NavigationBarDisable.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

struct View05_NavigationBarDisable: View {
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

struct View05_NavigationBarDisable_Previews: PreviewProvider {
    static var previews: some View {
        AdaptiveNavigationView {
            View05_NavigationBarDisable(NavigationFeatureItem(style: .navigationBarDisable))
        }
    }
}
