//
// NXNavigationExtension+SwiftUI.swift
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

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension NXNavigationRouter {
    
    @discardableResult
    /// 弹出当前页面。
    /// 比如：`["/", "/index"]` called: pop()  -> `["/"]`
    /// - Parameter animated: 是否使用转场动画
    /// - Returns: 本次操作是否成功
    func pop(_ animated: Bool = true) -> Bool {
        return popUntil("", animated)
    }
    
    @discardableResult
    /// 弹出到根页面。
    /// 比如：`["/", "/index", "/custom"]` called: `popToRoot()` -> `["/"]`
    /// - Parameter animated: 是否使用转场动画
    /// - Returns: 本次操作是否成功
    func popToRoot(_ animated: Bool = true) -> Bool {
        return popUntil("/", animated)
    }
    
    @discardableResult
    /// 弹出到 `routeName` 指定的页面。
    /// 比如：`["/", "/index", "/custom"]` called: `popUntil("/index")` -> `["/", "index"]`
    /// - Parameters:
    ///   - routeName: 指定跳转的路由名称
    ///   - animated: 是否使用转场动画
    /// - Returns: 本次操作是否成功
    func popUntil(_ routeName: String, _ animated: Bool = true) -> Bool {
        return popToLastUntil(routeName, animated)
    }
    
    @discardableResult
    /// 弹出到 `routeName` 指定的第一个页面。
    /// 比如：`["/", "/index", "/index", "/custom", "/index"]` called: `popToFirstUntil("/index")` -> `["/", "index"]`
    /// - Parameters:
    ///   - routeName: 指定跳转的路由名称
    ///   - animated: 是否使用转场动画
    /// - Returns: 本次操作是否成功
    func popToFirstUntil(_ routeName: String, _ animated: Bool = true) -> Bool {
        return __pop(withRouteName: routeName, animated: animated, isReverse: false)
    }
    
    @discardableResult
    /// 弹出到 `routeName` 指定的第最后一个页面。
    /// 比如：`["/", "/index", "/index", "/custom", "/index"]` called: `popToLastUntil("/index")` -> `["/", "/index", "/index"]`
    /// - Parameters:
    ///   - routeName: 指定跳转的路由名称
    ///   - animated: 是否使用转场动画
    /// - Returns: 本次操作是否成功
    func popToLastUntil(_ routeName: String, _ animated: Bool = true) -> Bool {
        return __pop(withRouteName: routeName, animated: animated, isReverse: true)
    }
    
}


@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public extension View {
    
    /// 通过 View 添加 `NXNavigationBar` 的包装对象，提供当前导航栏的外观的便利。
    /// - Parameter context: 当前对象的 NXNavigationRouter.Context 实例对象
    /// - Returns: 返回高度为 0，宽度为 0，并且是隐藏的 View
    ///
    /// import SwiftUI
    /// import NXNavigationExtension
    ///
    /// struct ContentView: View {
    ///     @State private var context: NXNavigationRouter.Context
    ///
    ///     init() {
    ///         context = NXNavigationRouter.Context(routeName: "/index")
    ///     }
    ///
    ///     var body: some View {
    ///         NavigationView {
    ///             NavigationLink {
    ///                 Button {
    ///                     NXNavigationRouter.of(context).pop()
    ///                 } label: {
    ///                     Text("Pop")
    ///                 }
    ///             } label: {
    ///                 Text("NXNavigationExtension")
    ///                     .padding()
    ///                     .useNXNavigationView(context: $context)
    ///             }
    ///         }
    ///     }
    /// }
    func useNXNavigationView(context: Binding<NXNavigationRouter.Context>) -> some View {
        useNXNavigationView(context: context, onPrepareConfiguration: nil, onWillPopViewController: nil)
    }
    
    /// 通过 View 添加 `NXNavigationBar` 的包装对象，提供当前导航栏的外观的便利。
    /// - Parameter onPrepareConfiguration: 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
    /// - Returns: 返回高度为 0，宽度为 0，并且是隐藏的 View
    ///
    /// import SwiftUI
    /// import NXNavigationExtension
    ///
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationView {
    ///             NavigationLink {
    ///                 Text("Destination")
    ///                     .padding()
    ///             } label: {
    ///                 Text("NXNavigationExtension")
    ///                     .padding()
    ///                     .useNXNavigationView { configuration in
    ///                         configuration.navigationBarAppearance.backgroundColor = .blue
    ///                     }
    ///             }
    ///         }
    ///     }
    /// }
    func useNXNavigationView(onPrepareConfiguration: @escaping (NXNavigationConfiguration) -> Void) -> some View {
        useNXNavigationView(context: .constant(NXNavigationRouter.Context(routeName: "")), onPrepareConfiguration: onPrepareConfiguration, onWillPopViewController: nil)
    }
    
    /// 通过 View 添加 `NXNavigationBar` 的包装对象，提供当前导航栏的外观的便利。
    /// - Parameter onWillPopViewController: 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
    /// 执行 `NXNavigationRouter.of(context).nx.\pop()\popToRoot()\popUntil("routeName")\popToFirstUntil("routeName")\popToLastUntil("routeName")` 等方法后也会触发这个代理回调
    /// - Returns: 返回高度为 0，宽度为 0，并且是隐藏的 View
    ///
    /// import SwiftUI
    /// import NXNavigationExtension
    ///
    /// struct ContentView: View {
    ///     var body: some View {
    ///         NavigationView {
    ///             NavigationLink {
    ///                 Text("Destination")
    ///                     .padding()
    ///             } label: {
    ///                 Text("NXNavigationExtension")
    ///                     .padding()
    ///                     .useNXNavigationView(onWillPopViewController: { interactiveType in
    ///                         switch interactiveType {
    ///                         case .backButtonAction, .backButtonMenuAction, .callNXPopMethod, .popGestureRecognizer:
    ///                             /// Do something...
    ///                             return false
    ///                         default:
    ///                             /// Do an other something...
    ///                             return true
    ///                         }
    ///                     })
    ///             }
    ///         }
    ///     }
    /// }
    func useNXNavigationView(onWillPopViewController: @escaping (NXNavigationInteractiveType) -> Bool) -> some View {
        useNXNavigationView(context: .constant(NXNavigationRouter.Context(routeName: "")), onPrepareConfiguration: nil, onWillPopViewController: onWillPopViewController)
    }
    
    /// 通过 View 添加 `NXNavigationBar` 的包装对象，提供当前导航栏的外观的便利。
    /// - Parameters:
    ///   - context: 当前对象的 NXNavigationRouter.Context 实例对象
    ///   - onPrepareConfiguration: 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
    ///   - onWillPopViewController: 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
    ///   执行 `NXNavigationRouter.of(context).nx.\pop()\popToRoot()\popUntil("routeName")\popToFirstUntil("routeName")\popToLastUntil("routeName")` 等方法后也会触发这个代理回调
    /// - Returns: 返回高度为 0，宽度为 0，并且是隐藏的 View
    func useNXNavigationView(context: Binding<NXNavigationRouter.Context>,
                             onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)? = nil,
                             onWillPopViewController: ((NXNavigationInteractiveType) -> Bool)? = nil) -> some View {
        let view = NXNavigationWrapperView(context: context,
                                           onPrepareConfiguration: onPrepareConfiguration,
                                           onWillPopViewController: onWillPopViewController)
            .frame(width: 0, height: 0)
        
        return ZStack {
            if #available(iOS 15.0, *) {
                overlay { view }
            } else {
                overlay(view)
            }
        }
    }
    
}
