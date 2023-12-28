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


#if canImport(SwiftUI)
import SwiftUI

#if SWIFT_PACKAGE
import NXNavigationExtension
#endif

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public class NXNavigationVirtualView: NXNavigationVirtualWrapperView {
    
    /// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
    var onBackActionHandler: ((NXNavigationBackAction) -> Bool)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 重写基类的代理方法。
    public override func nx_navigationTransition(_ transitionViewController: UIViewController, 
                                                 navigationBackAction action: NXNavigationBackAction) -> Bool {
        return self.onBackActionHandler?(action) ?? true
    }
    
    /// 重写基类的查找规则。
    public override class func configureWithDefaultRule(for hostingController: UIViewController) -> Self? {
        guard let view = hostingController.view else { return nil }
        if let navigationVirtualWrapperView = hostingController.nx_navigationVirtualWrapperView as? Self {
            return navigationVirtualWrapperView
        }
        
        let hostingViewClassName = NSStringFromClass(type(of: view))
        guard hostingViewClassName.contains("SwiftUI") || hostingViewClassName.contains("HostingView") else { return nil }
        
        var navigationVirtualWrapperView: Self?
        for wrapperView in view.subviews {
            let wrapperViewClassName = NSStringFromClass(type(of: wrapperView))
            if wrapperViewClassName.contains("ViewHost") && wrapperViewClassName.contains("NXNavigationWrapperView") {
                for subview in wrapperView.subviews {
                    if let virtualWrapperView = subview as? Self {
                        navigationVirtualWrapperView = virtualWrapperView
                        break
                    }
                }
            }
        }
        
        return navigationVirtualWrapperView
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct NXNavigationWrapperView: UIViewRepresentable {
    public typealias UIViewType = NXNavigationVirtualView
    
    /// NXNavigationVirtualView 实例对象
    private let virtualView = NXNavigationVirtualView()
    
    /// 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
    private var onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)?
    
    /// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
    private var onBackActionHandler: ((NXNavigationBackAction) -> Bool)?
    
    /// 初始化方法
    /// - Parameters:
    ///   - context: 当前对象的 NXNavigationRouter.Context 实例对象
    ///   - onPrepareConfiguration: 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
    ///   - onBackActionHandler: 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
    init(context: Binding<NXNavigationRouter.Context>,
         onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)? = nil,
         onBackActionHandler: ((NXNavigationBackAction) -> Bool)? = nil) {
        self.virtualView.context = context.wrappedValue
        self.onPrepareConfiguration = onPrepareConfiguration
        self.onBackActionHandler = onBackActionHandler
    }
    
    public func makeUIView(context: Context) -> NXNavigationVirtualView {
        virtualView.prepareConfigurationCallback = onPrepareConfiguration;
        virtualView.onBackActionHandler = onBackActionHandler
        return virtualView
    }
    
    public func updateUIView(_ uiView: NXNavigationVirtualView, context: Context) {
        // Nothing...
    }
    
    /// 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
    /// - Parameters:
    ///   - viewController: 当前的 UIHostingController
    ///   - configuration: 设置当前视图控制器的配置信息
    private func onPrepareConfiguration(viewController: UIViewController, configuration: NXNavigationConfiguration) {
        onPrepareConfiguration?(configuration)
    }
    
}

#endif
