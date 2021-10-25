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

import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, *)
public extension NXNavigationRouter {
    
    @discardableResult
    func pop(_ animated: Bool = true) -> Bool {
        return pop("", animated)
    }
    
    @discardableResult
    func pop(_ routeName: String = "", _ animated: Bool = true) -> Bool {
        return __pop(withRouteName: routeName, animated: animated)
    }
    
}


@available(iOS 13.0, *)
public extension View {
    
    func useNXNavigationView(routeName: String) -> some View {
        useNXNavigationView(routeName: routeName, onPrepareConfiguration: nil, onContextChanged: nil, onWillPopViewController: nil)
    }
    
    func useNXNavigationView(onPrepareConfiguration: @escaping (NXNavigationConfiguration) -> Void) -> some View {
        useNXNavigationView(routeName: "", onPrepareConfiguration: onPrepareConfiguration)
    }
    
    func useNXNavigationView(onContextChanged: @escaping (NXNavigationContext) -> Void) -> some View {
        useNXNavigationView(routeName: "", onContextChanged: onContextChanged)
    }
    
    func useNXNavigationView(onWillPopViewController: @escaping (NXNavigationInteractiveType) -> Bool) -> some View {
        useNXNavigationView(routeName: "", onWillPopViewController: onWillPopViewController)
    }
    
    func useNXNavigationView(routeName: String = "",
                             onPrepareConfiguration: ((NXNavigationConfiguration) -> Void)? = nil,
                             onContextChanged: ((NXNavigationContext) -> Void)? = nil,
                             onWillPopViewController: ((NXNavigationInteractiveType) -> Bool)? = nil) -> some View {
        let view = NXNavigationWrapperView(
            routeName: routeName,
            onPrepareConfiguration: onPrepareConfiguration,
            onContextChanged: onContextChanged,
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

