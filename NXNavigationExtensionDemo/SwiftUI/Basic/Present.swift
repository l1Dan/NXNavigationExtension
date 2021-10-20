//
//  Present.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/17.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13, *)
struct Present: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var presentedAsModal: Bool
    
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem, presentedAsModal: Binding<Bool>) {
        self.item = item
        self._presentedAsModal = presentedAsModal
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .navigationBarItems(leading:Button (action: {
                self.presentedAsModal = false
            }, label: {
                Image(systemName: "xmark")
            }).foregroundColor(colorScheme == .dark ? Color.white : Color.black))
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = .clear
                configuration.viewControllerPreferences.useBlurNavigationBar = true
            }
    }
}

@available(iOS 13, *)
struct Present_Previews: PreviewProvider {
    @State static var presentedAsModal = false
    static var previews: some View {
        NavigationView {
            Present(NavigationFeatureItem(style: .present), presentedAsModal: $presentedAsModal)
        }
    }
}
