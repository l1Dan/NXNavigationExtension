//
//  ViewController06_WebView.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit
import WebKit
import NXNavigationExtension

class ViewController06_WebView: BaseViewController, WKNavigationDelegate {
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .customLightGray
        progressView.progressTintColor = .customDarkGray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.alpha = 0.0
        return progressView
    }()
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 9.0
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.decelerationRate = .normal
        webView.scrollView.keyboardDismissMode = .onDrag
        webView.allowsBackForwardNavigationGestures = true
        webView.gestureRecognizers?.last?.isEnabled = false
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let customView = UIButton(type: .custom)
        customView.setImage(UIImage(named: "NavigationBarBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customView.tintColor = .customTitle
        customView.sizeToFit()
        customView.addTarget(self, action: #selector(clickBackButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: customView)
    }()
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let customView = UIButton(type: .custom)
        customView.setImage(UIImage(named: "NavigationBarClose")?.withRenderingMode(.alwaysTemplate), for: .normal)
        customView.tintColor = .customTitle
        customView.sizeToFit()
        customView.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: customView)
    }()
    
    private func updateLeftButtonItems() {
        if UIDevice.isPhoneDevice {
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
    
    @objc
    private func clickBackButton(_ button: UIButton) {
        if UIDevice.isPhoneDevice {
            navigationController?.nx_popViewController(animated: true)
        } else {
            if webView.canGoBack {
                webView.goBack()
            }
        }
    }
    
    @objc
    private func clickCloseButton(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func clickAddButton(_ button: UIButton) {
        navigationController?.pushViewController(ViewController07_UpdateNavigationBar(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Loading..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickAddButton(_:)))
        
        estimatedProgressObservation = webView.observe(\.self.estimatedProgress, options: .new) { [weak self] webView, value in
            self?.progressView.alpha = 1.0
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut) {
                    self?.progressView.alpha = 0.0
                } completion: { finished in
                    self?.progressView.setProgress(0.0, animated: true)
                }
            }
        }
        
        titleObservation = webView.observe(\.self.title, options: .new, changeHandler: { [weak self] webView, value in
            self?.navigationItem.title = webView.title
        })
        
        if UIDevice.isPhoneDevice {
            navigationItem.leftBarButtonItems = [backBarButtonItem]
        }
        
        webView.load(URLRequest(url: URL(string: "https://www.apple.com/")!))
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
        ])
        
        if #available(iOS 13.0, *) {
            webView.backgroundColor = UIColor(dynamicProvider: { [weak self] traitCollection in
                guard let self = self else { return .white }
                if self.view.traitCollection.userInterfaceStyle == .dark {
                    self.webView.isOpaque = false
                    return .clear
                }
                self.webView.isOpaque = true
                return .white
            })
        } else {
            webView.isOpaque = true
            webView.backgroundColor = nil
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressView.isHidden = true
    }

    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        updateLeftButtonItems()
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateLeftButtonItems()
    }

}

extension ViewController06_WebView {
    
    override var nx_navigationBarBackgroundColor: UIColor? {
        return randomColor
    }

    // MARK: - NXNavigationControllerDelegate

    func nx_navigationController(_ navigationController: UINavigationController, willPop viewController: UIViewController, interactiveType: NXNavigationInteractiveType) -> Bool {
        if interactiveType != .popGestureRecognizer && webView.canGoBack {
            webView.goBack()
            return false
        }
        return true
    }

}
