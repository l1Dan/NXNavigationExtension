//
//  ContentView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2025/6/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 18.0, *) {
            TabView {
                Tab("UIKit", systemImage: "cross.case") {
                    UIKitContentView()
                        .ignoresSafeArea()
                }
                Tab("SwiftUI", systemImage: "swift") {
                    SwiftUIContentView()
                }
            }
        } else {
            TabView {
                UIKitContentView()
                    .ignoresSafeArea()
                    .tabItem {
                        Label("UIKit", systemImage: "cross.case")
                    }
                UIKitContentView()
                    .ignoresSafeArea()
                    .tabItem {
                        Label("UIKit", systemImage: "cross.case")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
