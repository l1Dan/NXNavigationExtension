//
//  CustomBackView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/20.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct CustomBackView: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backButtonCustomView = CustomBackView.backButton
            }
    }
    
    private static var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("😋", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left.2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return backButton;
    }()
}

@available(iOS 13.0, *)
struct CustomBackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomBackView(NavigationFeatureItem(style: .customBackView))
        }
    }
}
