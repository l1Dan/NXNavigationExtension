//
//  View08_CustomBackView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/20.
//

import NXNavigationExtension
import NXNavigationExtensionSwiftUI
import SwiftUI

struct View08_CustomBackView: View {

    private let item: NavigationFeatureItem

    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        ColorListView()
            .navigationBarTitle(LocalizedStringKey(item.title))
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backButtonCustomView = View08_CustomBackView.backButton
            }
    }

    private static var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("😋", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left.2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        return backButton
    }()
}

#Preview {
    AdaptiveNavigationView {
        View08_CustomBackView(NavigationFeatureItem(style: .customBackView))
    }
}
