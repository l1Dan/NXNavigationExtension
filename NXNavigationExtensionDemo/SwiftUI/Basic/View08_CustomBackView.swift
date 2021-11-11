//
//  View08_CustomBackView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/20.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
struct View08_CustomBackView: View {
    private let item: NavigationFeatureItem
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }
    
    var body: some View {
        ColorListView()
            .navigationBarTitle(item.title)
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backButtonCustomView = View08_CustomBackView.backButton
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
struct View08_CustomBackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            View08_CustomBackView(NavigationFeatureItem(style: .customBackView))
        }
    }
}
