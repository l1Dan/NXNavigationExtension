//
//  ViewController08_WebView.swift
//  UNXNavigatorSwiftDemo
//
//  Created by Leo Lee on 2020/11/23.
//

import UIKit
import WebKit
import UNXNavigator

class ViewController08_WebView: BaseViewController {
    
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?

    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: .zero)
        progressView.trackTintColor = .customLightGray
        progressView.progressTintColor = .customDarkGray
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    fileprivate lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 9.0
        configuration.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.decelerationRate = .normal
        webView.scrollView.keyboardDismissMode = .onDrag
        webView.allowsBackForwardNavigationGestures = true
        webView.gestureRecognizers?.last?.isEnabled = false
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let customView = UIButton(type: .custom)
        customView.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customView.tintColor = .customTitle
        customView.sizeToFit()
        customView.addTarget(self, action: #selector(clickBackBarButtonItem(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: customView)
    }()
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let customView = UIButton(type: .custom)
        customView.setImage(UIImage(named: "NavigationBarClose")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customView.tintColor = .customTitle
        customView.sizeToFit()
        customView.addTarget(self, action: #selector(clickCloseBarButtonItem(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: customView)
    }()
    
    private lazy var requestURL: URL = URL(string: "https://l1dan.gitee.io/")!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Loading..."
        
        if UIDevice.isPhone {
            navigationItem.leftBarButtonItems = [self.backBarButtonItem]
        }

        view.addSubview(webView)
        unx_navigationBar.addSubview(progressView)
        webView.load(URLRequest(url: requestURL))

        progressView.topAnchor.constraint(equalTo: unx_navigationBar.bottomAnchor).isActive = true
        progressView.leftAnchor.constraint(equalTo: unx_navigationBar.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: unx_navigationBar.rightAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        if #available(iOS 13.0, *) {
            webView.backgroundColor = UIColor(dynamicProvider: { [weak self] traitCollection -> UIColor in
                guard let self = self else { return UIColor.white }
                if traitCollection.userInterfaceStyle == .dark {
                    self.webView.isOpaque = false
                    return UIColor.clear
                }
                self.webView.isOpaque = true
                return UIColor.white
            })
        } else {
            webView.isOpaque = true
            webView.backgroundColor = nil
        }
        
        titleObservation = webView.observe(\.title, options: .new) { [weak self] (webView, title) in
            self?.navigationItem.title = webView.title
        }
        
        progressObservation = webView.observe(\.estimatedProgress, options: .new) { [weak self] (webView, estimatedProgress) in
            self?.progressView.alpha = 1.0
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut) {
                    self?.progressView.alpha = 0.0
                } completion: { _ in
                    self?.progressView.setProgress(0.0, animated: false)
                }
            }
        }
    }
    
    override var unx_useSystemBlurNavigationBar: Bool {
        return true
    }
    
    deinit {
        print(#function)
    }
    
}

@objc
extension ViewController08_WebView {
    
    private func clickBackBarButtonItem(_ item: UIBarButtonItem) {
        if UIDevice.isPhone {
            navigationController?.unx_triggerSystemBackButtonHandler()
        } else {
            if webView.canGoBack {
                webView.goBack()
            }
        }
    }
    
    private func clickCloseBarButtonItem(_ item: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ViewController08_WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if UIDevice.isPhone {
            if webView.canGoBack {
                navigationItem.leftBarButtonItems = [backBarButtonItem, closeBarButtonItem]
            } else {
                navigationItem.leftBarButtonItems = [backBarButtonItem]
            }
        } else {
            if webView.canGoBack {
                navigationItem.leftBarButtonItems = [backBarButtonItem]
            } else {
                navigationItem.leftBarButtonItems = nil
            }
        }
    }
}

extension ViewController08_WebView: UNXNavigatorInteractable {
    
    func navigationController(_ navigationController: UINavigationController, willPopViewControllerUsingInteractingGesture interactingGesture: Bool) -> Bool {
        if !interactingGesture && webView.canGoBack {
            webView.goBack()
            return false
        }
        return true
    }
    
}
