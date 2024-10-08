//
//  ContentView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/12.
//

import SwiftUI
import NXNavigationExtensionSwiftUI

struct ContentView: View {
    let sections = NavigationFeatureSection.sections(for: false)
    
    var body: some View {
        AdaptiveNavigationView {
            if #available(iOS 14.0, *) {
                FeatureListView(sections)
                    .navigationBarTitle("SwiftUI🎉🎉🎉")
                    .useNXNavigationView(onPrepareConfiguration: { configuration in
                        configuration.navigationBarAppearance.backgroundColor = .customDarkGray
                        configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                    })
            } else {
                Text("Hello, NXNavigationExtension")
            }
        }
    }
}

#Preview {
    ContentView()
}

