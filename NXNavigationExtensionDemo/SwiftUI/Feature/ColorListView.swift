//
//  ColorListView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct ColorListView: View {
    @Environment(\.colorScheme) private var colorScheme;
    
    var body: some View {
        List(0 ..< 30) { index in
            NavigationLink {
                UpdateNavigationBar(NavigationFeatureItem(style: .updateNavigationBar))
            } label: {
                Text(String(format: "Row: %02zd", index + 1))
            }
            .listRowBackground(Color( colorScheme == .dark ? UIColor.randomDark : UIColor.randomLight))

        }.listStyle(.plain)
    }

}

@available(iOS 13.0, *)
struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorListView()
        }
    }
}
