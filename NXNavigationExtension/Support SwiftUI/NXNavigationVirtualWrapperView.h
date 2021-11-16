//
// NXNavigationVirtualWrapperView.h
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

#import <UIKit/UIKit.h>

#if __has_include(<NXNavigationExtension/NXNavigationExtension.h>)

#import <NXNavigationExtension/NXNavigationConfiguration.h>

#else

#import "NXNavigationConfiguration.h"

#endif /* __has_include */

NS_ASSUME_NONNULL_BEGIN

@class NXNavigationConfiguration, NXNavigationRouterContext;

API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0))
@interface NXNavigationVirtualWrapperView : UIView <NXNavigationInteractable>

/// 当前 UIHostingController ContentView 的 NXNavigationRouterContext 对象
@property (nonatomic, strong, nullable) NXNavigationRouterContext *context;

/// 即将应用配置到当前视图控制器的回调，执行 `setNeedsNavigationBarAppearanceUpdate` 方法时也会触发此回调。
@property (nonatomic, copy, nullable) NXViewControllerPrepareConfigurationCallback prepareConfigurationCallback;

/// 筛选当前 UIHostingController 使用的 NXNavigationVirtualWrapperView 实例对象，开发者可以自定义查找规则（如果内部查找规则无效的情况下）。
/// @param hostingController SwiftUI 中实际使用的视图控制器，需要子类实现。
+ (nullable instancetype)configureWithDefaultRuleForViewController:(__kindof UIViewController *)hostingController;

@end

NS_ASSUME_NONNULL_END
