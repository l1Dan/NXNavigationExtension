//
//  AdaptiveNavigationView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2023/12/25.
//

import SwiftUI

struct AdaptiveNavigationView<Root> : View where Root : View {
    private let root: (() -> Root)
    
    init(@ViewBuilder root: @escaping () -> Root) {
        self.root = root
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                root()
            }
        } else {
            NavigationView {
                root()
            }
            .navigationViewStyle(.stack)
        }
    }
}

#Preview {
    AdaptiveNavigationView {
        Text("Hello")
    }
}
