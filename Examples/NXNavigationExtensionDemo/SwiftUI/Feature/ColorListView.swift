//
//  ColorListView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

@available(iOS 14.0, *)
struct ColorListView: View {
    @Environment(\.colorScheme) private var colorScheme;
    
    var body: some View {
        List(0 ..< 30) { index in
            NavigationLink {
                View07_UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBar))
            } label: {
                Text(String(format: "Row: %02zd", index + 1))
            }
            .listRowBackground(Color( colorScheme == .dark ? UIColor.randomDark : UIColor.randomLight))

        }.listStyle(.plain)
    }

}

@available(iOS 14.0, *)
#Preview {
    AdaptiveNavigationView {
        ColorListView()
    }
}
