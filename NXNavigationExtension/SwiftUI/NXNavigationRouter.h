//
// NXNavigationRouter.h
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

NS_ASSUME_NONNULL_BEGIN


API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0))
NS_SWIFT_NAME(NXNavigationRouter.Context) @interface NXNavigationRouterContext : NSObject

/// 路由名称
@property (nonatomic, copy, readonly) NSString *routeName;

/// SwiftUI ContentView 所在的 UIHostingController
@property (nonatomic, weak, nullable) __kindof UIViewController *hostingController;

/// 初始化 NXNavigationRouterContext 对象
/// @param routeName 路由名称
- (instancetype)initWithRouteName:(nullable NSString *)routeName;

/// 便利构造函数
/// @param routeName 路由名称
+ (instancetype)navigationRouterContextWithRouteName:(nullable NSString *)routeName;

@end

API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0))
@interface NXNavigationRouter : NSObject

/// 调用 `nx_` 开头的方法；比如：NXNavigationRouter.of(context).nx./pop()/popUntil("routeName")...
@property (nonatomic, strong, readonly) NXNavigationRouter *nx;

/// 获取 NXNavigationRouter 对象
/// @param context 当前使用的 NXNavigationRouterContext 对象
+ (instancetype)of:(NXNavigationRouterContext *)context;

/// The same as UIViewController `nx_setNeedsNavigationBarAppearanceUpdate` instance.
- (void)setNeedsNavigationBarAppearanceUpdate;

/// 通过路由名称得到可以弹出的目标视图控制器
/// @param routeName 路由名称
/// @param isReverse 遇到相同的路由名称时，是从栈头还是栈尾弹出视图控制器。
- (nullable __kindof UIViewController *)destinationViewControllerWithRouteName:(NSString *)routeName isReverse:(BOOL)isReverse;

/// 用于适配调用系统 `pop` 系列或者 `nx_pop` 系列方法
/// @param routeName 路由名称
/// @param animated 是否使用转场动画
/// @param isReverse 遇到相同的路由名称时，是从栈头还是栈尾弹出视图控制器。
- (BOOL)popWithRouteName:(NSString *)routeName animated:(BOOL)animated isReverse:(BOOL)isReverse NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
