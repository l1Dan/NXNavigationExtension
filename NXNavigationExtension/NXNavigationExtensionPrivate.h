//
// NXNavigationExtensionPrivate.h
//
// Copyright (c) 2021 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import "NXNavigationBar.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UINavigationBarDidUpdateFrameHandler)(CGRect frame);

/// 边缘滑动返回手势代理
@interface NXEdgeGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

/// 全屏滑动返回手势代理
@interface NXFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

@interface UIScrollView (NXNavigationExtensionPrivate)

@property (nonatomic, strong) NXNavigationBar *nx_navigationBar;

@end

@interface UIView (NXNavigationExtensionPrivate)

/// UINavigatoinBar layoutSubviews 时调用
@property (nonatomic, copy, nullable) UINavigationBarDidUpdateFrameHandler nx_didUpdateFrameHandler;

/// 阻止事件被 NavigationBar 接收，需要将事件穿透传递到下层
@property (nonatomic, assign) BOOL nx_disableUserInteraction;

/// 正在显示返回按钮历史菜单
@property (nonatomic, assign) BOOL nx_showingBackButtonMenu;

@end

@interface UIViewController (NXNavigationExtensionPrivate)

/// 设置 UINavigationBarItem
- (void)nx_configureNavigationBarItemWithViewConstrollers:(NSArray<__kindof UIViewController *> *)viewControllers;

@end

@interface UINavigationController (NXNavigationExtensionPrivate)

/// 获取当前皮肤设置
@property (nonatomic, strong) NXEdgeGestureRecognizerDelegate *nx_gestureDelegate;

/// 获取当前皮肤设置
@property (nonatomic, strong, readonly, nullable) NXNavigationBarAppearance *nx_appearance;

/// 全屏收拾代理对象
@property (nonatomic, strong, readonly) NXFullscreenPopGestureRecognizerDelegate *nx_fullscreenPopGestureDelegate;

/// NXNavigationBar 是否可用；默认 YES；没有注册导航栏时为 NO 时会使用系统导航栏
@property (nonatomic, assign, readonly) BOOL nx_useNavigationBar;

/// 配置 NXNavigationBar
- (void)nx_configureNavigationBar;

@end

NS_ASSUME_NONNULL_END
