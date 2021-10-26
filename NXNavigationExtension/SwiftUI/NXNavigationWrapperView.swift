//
// NXNavigationWrapperView.swift
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
public class NXNavigationVirtualView: NXNavigationVirtualWrapperView {
    
    var onWillPopViewController: ((NXNavigationInteractiveType) -> Bool)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func nx_navigationController(_ navigationController: UINavigationController,
                                                 willPop viewController: UIViewController,
                                                 interactiveType: NXNavigationInteractiveType) -> Bool {
        return self.onWillPopViewController?(interactiveType) ?? true
    }
}

@available(iOS 13.0, *)
public struct NXNavigationWrapperView: UIViewRepresentable {
    public typealias UIViewType = NXNavigationVirtualView
    
    private let virtualView = NXNavigationVirtualView()
    private var onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)?
    private var onContextChanged: ((NXNavigationContext) -> Void)? = nil
    private var onWillPopViewController: ((NXNavigationInteractiveType) -> Bool)?
    
    init(routeName: String = "",
         onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)? = nil,
         onContextChanged: ((NXNavigationContext) -> Void)? = nil,
         onWillPopViewController: ((NXNavigationInteractiveType) -> Bool)? = nil) {
        self.virtualView.routeName = routeName
        self.onPrepareConfiguration = onPrepareConfiguration
        self.onContextChanged = onContextChanged
        self.onWillPopViewController = onWillPopViewController
    }
    
    public func makeUIView(context: Context) -> NXNavigationVirtualView {
        virtualView.prepareConfigurationCallback = onPrepareConfiguration;
        virtualView.onWillPopViewController = onWillPopViewController
        return virtualView
    }
    
    public func updateUIView(_ uiView: NXNavigationVirtualView, context: Context) {
        // Nothing...
    }
    
    private func onPrepareConfiguration(viewController: UIViewController, configuration: NXNavigationConfiguration) {
        onPrepareConfiguration?(configuration)
        onContextChanged?(virtualView)
        viewController.nx_setNeedsNavigationBarAppearanceUpdate()
    }
    
}
