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
#import <NXNavigationExtension/NXNavigationRouter.h>

#else

#import "NXNavigationConfiguration.h"
#import "NXNavigationRouter.h"

#endif /* __has_include */

NS_ASSUME_NONNULL_BEGIN

@class NXNavigationConfiguration;

API_AVAILABLE(ios(13.0), tvos(13.0))
@interface NXNavigationVirtualWrapperView : UIView <NXNavigationInteractable, NXNavigationContext>

@property (nonatomic, copy, nullable) NSString *routeName;

/// NXNavigationVirtualWrapperView 实际所在的视图控制器
@property (nonatomic, weak, nullable, readonly) __kindof UIViewController *hostingController;

/// 执行 UIViewController 生命周期时系统自动调用，每个 UIViewController 实例会调用多次。即将应用配置到当前视图控制器的回调
@property (nonatomic, copy, nullable) NXNavigationPrepareConfigurationCallback prepareConfigurationCallback;

/// 筛选当前 UIHostingController 使用的 NXNavigationVirtualWrapperView 实例对象，开发者可以自定义查找规则（如果内部查找规则无效的情况下）。
/// @param hostingController SwiftUI 中实际使用的视图控制器
+ (nullable NXNavigationVirtualWrapperView *)filterNavigationVirtualWrapperViewWithViewController:(__kindof UIViewController *)hostingController;

@end

NS_ASSUME_NONNULL_END
