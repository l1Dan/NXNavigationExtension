//
//  View06_WebView.swift
//  NXNavigationExtensionSwiftUIDemo
//
//  Created by lidan on 2021/10/15.
//

import SwiftUI
import WebKit

struct WebViewWrapperView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: "https://www.apple.com/")!))
    }
    
}

struct View06_WebView: View {
    
    private let item: NavigationFeatureItem
    private let randomColor = UIColor.randomLight
    
    init(_ item: NavigationFeatureItem) {
        self.item = item
    }

    var body: some View {
        WebViewWrapperView()
            .useNXNavigationView { configuration in
                configuration.navigationBarAppearance.backgroundColor = randomColor
            }
    }
}

#Preview {
    AdaptiveNavigationView {
        View06_WebView(NavigationFeatureItem(style: .webView))
    }
}
