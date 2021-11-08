//
//  WebView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/15.
//

import WebKit

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
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

@available(iOS 13.0, *)
struct WebView: View {
    
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

@available(iOS 13.0, *)
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WebView(NavigationFeatureItem(style: .webView))
        }
    }
}
