//
//  ContentView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/11/12.
//

import SwiftUI

struct ContentView: View {
    let sections = NavigationFeatureSection.sections(for: false)
    
    var body: some View {
        AdaptiveNavigationView {
            FeatureListView(sections)
                .navigationBarTitle("SwiftUI🎉🎉🎉")
                .useNXNavigationView(onPrepareConfiguration: { configuration in
                    configuration.navigationBarAppearance.backgroundColor = .customDarkGray
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

