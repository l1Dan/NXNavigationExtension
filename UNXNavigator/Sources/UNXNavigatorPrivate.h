//
// UNXNavigatorPrivate.h
//
// Copyright (c) 2021 Leo Lee UNXNavigator (https://github.com/l1Dan/UNXNavigator)
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
#import "UNXNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^UINavigationBarDidUpdateFrameHandler)(CGRect frame);

/// 边缘滑动返回手势代理
@interface UEEdgeGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

/// 全屏滑动返回手势代理
@interface UEFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

@interface UIScrollView (UNXNavigatorPrivate)

@property (nonatomic, strong) UNXNavigationBar *unx_navigationBar;

@end

@interface UINavigationBar (UNXNavigatorPrivate)

/// UINavigatoinBar layoutSubviews 时调用
@property (nonatomic, copy, nullable) UINavigationBarDidUpdateFrameHandler unx_didUpdateFrameHandler;

/// 阻止事件被 NavigationBar 接收，需要将事件穿透传递到下层
@property (nonatomic, assign) BOOL unx_disableUserInteraction;

@end

@interface UIViewController (UNXNavigatorPrivate)

/// 设置 UINavigationBarItem
- (void)unx_configureNavigationBarItem;

/// 调用 popViewControllerAnimated: 方法
- (void)unx_triggerSystemPopViewController;

@end

@interface UINavigationController (UNXNavigatorPrivate)

/// 获取当前皮肤设置
@property (nonatomic, strong) UEEdgeGestureRecognizerDelegate *unx_gestureDelegate;

/// 获取当前皮肤设置
@property (nonatomic, strong, readonly, nullable) UNXNavigationBarAppearance *unx_appearance;

/// 全屏收拾代理对象
@property (nonatomic, strong, readonly) UEFullscreenPopGestureRecognizerDelegate *unx_fullscreenPopGestureDelegate;

/// UNXNavigationBar 是否可用；默认 YES；没有注册导航栏时为 NO 时会使用系统导航栏
@property (nonatomic, assign, readonly) BOOL unx_useNavigationBar;

/// 配置 UNXNavigationBar
- (void)unx_configureNavigationBar;

@end

NS_ASSUME_NONNULL_END
