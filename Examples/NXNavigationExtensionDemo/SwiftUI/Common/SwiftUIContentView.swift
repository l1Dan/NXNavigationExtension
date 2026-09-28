//
//  SwiftUIContentView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/12.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

struct SwiftUIContentView: View {

    let sections = NavigationFeatureSection.sections(for: false)

    var body: some View {
        AdaptiveNavigationView {
            FeatureListView(sections)
                .navigationBarTitle("SwiftUI🎉🎉🎉")
                .navigationBarTitleDisplayMode(.inline)
                .useNXNavigationView(onPrepareConfiguration: { configuration in
                    configuration.navigationBarAppearance.backgroundColor = .customDarkGray
                    configuration.navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                })
        }
    }
}

#Preview {
    SwiftUIContentView()
}
