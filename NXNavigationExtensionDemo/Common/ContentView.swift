//
//  ContentView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/14.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct ContentView: View {
    let sections = NavigationFeatureSection.sections
    
    var body: some View {
        NavigationView {
            FeatureListView(sections)
                .navigationBarTitle("SwiftUI🎉🎉🎉")
                .useNXNavigationView(onPrepareConfiguration: { configuration in
                    configuration.navigationBarAppearance.backgroundColor = .customDarkGray
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                })
        }
        .navigationViewStyle(.stack)
    }
}

@available(iOS 13, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
