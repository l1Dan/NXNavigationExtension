//
//  UIKitContentView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2025/6/18.
//

import SwiftUI

struct UIKitContentView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SlidingNavigationController

    func makeUIViewController(context: Context) -> SlidingNavigationController {
        let viewController = FeatureTableViewController(style: .insetGrouped)
        let navigationController = SlidingNavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "UIKit🎉🎉🎉"
        return navigationController
    }

    func updateUIViewController(_ uiViewController: SlidingNavigationController, context: Context) {}
}

#Preview {
    UIKitContentView()
        .ignoresSafeArea()
}
