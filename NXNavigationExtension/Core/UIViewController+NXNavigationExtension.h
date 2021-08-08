//
// UIViewController+NXNavigationExtension.h
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

@class NXNavigationBar;

/// 页面配置
@interface UIViewController (NXNavigationExtension)

/// 获取当前控制器 NXNavigationBar
@property (nonatomic, strong, readonly, nullable) NXNavigationBar *nx_navigationBar;

/// 设置 NavigationBar 背景颜色
@property (nonatomic, strong, readonly, nullable) UIColor *nx_navigationBarBackgroundColor;

/// 设置 NavigationBar 背景图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_navigationBarBackgroundImage;

/// 设置 NavigationBar barTintColor
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barBarTintColor;

/// 设置 NavigationBar tintColor (可以设置返回按钮颜色)
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barTintColor;

/// 设置 NavigationBar titleTextAttributes
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_titleTextAttributes;

/// 设置 NavigationBar largeTitleTextAttributes
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_largeTitleTextAttributes API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

/// 设置 NavigationBar 底部阴影图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_shadowImage;

/// 设置返回按钮图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_backImage;

/// 设置横屏时显示的图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_landscapeBackImage;

/// 设置 NavigationBar 底部阴影颜色
@property (nonatomic, strong, readonly, nullable) UIColor *nx_shadowImageTintColor;

/// 自定义返回按钮
@property (nonatomic, strong, readonly, nullable) UIView *nx_backButtonCustomView;

/// 设置返回按钮图片 `backImage` 的 insets，默认：UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets nx_backImageInsets;

/// 设置横屏时显示的图片 `landscapeBackImage` 的 insets，默认：UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets nx_landscapeBackImageInsets;

/// 是否使用系统模糊效果；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_useSystemBlurNavigationBar;

/// 是否禁用边缘滑动返回手势；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_disableInteractivePopGesture;

/// 是否使用全屏返回；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_enableFullScreenInteractivePopGesture;

/// 是否自动隐藏 NavigationBar；默认 YES
@property (nonatomic, assign, readonly) BOOL nx_automaticallyHideNavigationBarInChildViewController;

/// 是否隐藏导航栏（UINavigationBar 和 NXNavigationBar 都会隐藏）；默认 NO
/// 注意⚠️：这里并不是真正的隐藏导航栏，只是将导航栏变成透明，设置返回按钮透明，导航栏的 item(s) 和 title(view) 需要自己控制是否显示。
/// 这样做的目的是让导航栏下方的视图可以接收事件响应
@property (nonatomic, assign, readonly) BOOL nx_hidesNavigationBar;

/// 设置 NXNavigationBar 的 containerView 可以接收事件响应，还可以不跟随导航栏的透明度一起变化；默认 `NO`
/// 注意⚠️：系统返回按钮点击事件不可用，但系统返回按钮还是显示的，方便在 containerView 自定义返回按钮，
/// 也可以通过 `nx_barTintColor` 修改返回按钮颜色
@property (nonatomic, assign, readonly) BOOL nx_containerViewWithoutNavigtionBar;

/// 是否开启返回按钮菜单，默认 `NO`。如果设置为 `YES`需要同时设置 NXNavigationBarAppearance 属性 `backButtonMenuSupported = YES`
@property (nonatomic, assign, readonly) BOOL nx_backButtonMenuEnabled API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos, tvos);

/// 设置触发全屏手势返回，离左边最大滑动距离
@property (nonatomic, assign) CGFloat nx_interactivePopMaxAllowedDistanceToLeftEdge;

/// 触发导航栏外观更新
- (void)nx_setNeedsNavigationBarAppearanceUpdate;

@end

NS_ASSUME_NONNULL_END
