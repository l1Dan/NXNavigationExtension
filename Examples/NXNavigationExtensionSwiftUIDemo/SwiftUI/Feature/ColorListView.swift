//
//  ColorListView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI

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

struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewAdaptor {
            ColorListView()
        }
    }
}
