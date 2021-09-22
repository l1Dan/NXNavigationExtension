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

/// 设置横屏时显示的返回按钮图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_landscapeBackImage;

/// 设置 NavigationBar 底部阴影颜色
@property (nonatomic, strong, readonly, nullable) UIColor *nx_shadowImageTintColor;

/// 自定义返回按钮
@property (nonatomic, strong, readonly, nullable) UIView *nx_backButtonCustomView;

/// 设置返回按钮图片 `backImage` 的 insets，默认：UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets nx_backImageInsets;

/// 设置横屏时显示返回按钮图片 `landscapeBackImage` 的 insets，默认：UIEdgeInsetsZero
@property (nonatomic, assign, readonly) UIEdgeInsets nx_landscapeBackImageInsets;

@property (nonatomic, assign, readonly) BOOL nx_useSystemBlurNavigationBar API_DEPRECATED("Use nx_useBlurNavigationBar & nx_navigationBarBackgroundColor instead.", ios(2.0, 2.0));

/// 是否启用导航栏模糊效果；默认 NO。需要设置 nx_navigationBarBackgroundColor 的 alpha 颜色通道才会有模糊效果
/// 将 nx_navigationBarBackgroundColor 设置为 [UIColor clearColor]，可以实现类似系统导航栏的模糊效果
@property (nonatomic, assign, readonly) BOOL nx_useBlurNavigationBar;

/// 是否禁用边缘滑动返回手势；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_disableInteractivePopGesture;

@property (nonatomic, assign, readonly) BOOL nx_enableFullScreenInteractivePopGesture API_DEPRECATED("Use nx_enableFullscreenInteractivePopGesture instead.", ios(2.0, 2.0));

/// 是否使用全屏返回；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_enableFullscreenInteractivePopGesture;

/// 是否自动隐藏 NavigationBar；默认 YES
@property (nonatomic, assign, readonly) BOOL nx_automaticallyHideNavigationBarInChildViewController;

@property (nonatomic, assign, readonly) BOOL nx_hidesNavigationBar API_DEPRECATED("Use nx_translucentNavigationBar instead.", ios(2.0, 2.0));

/// 设置导航栏是否透明（类似导航栏隐藏的效果）。如果需要系统导航栏隐藏可以使用这个属性，不推荐直接设置系统导航栏的显示或隐藏。
/// 设置导航栏透明会将 self.navigationController.navigationBar.barTintColor/tintColor/titleTextAttributes/largeTitleTextAttributes 的颜色都设置为 [UIColor clearColor]
/// 还会将 self.navigationItem.titleView.hidden 属性设置为 YES，self.navigationController.navigationBar.userInteractionEnabled 属性设置为 NO，
/// 以达到导航栏“看起来”被隐藏了（系统导航栏实际上还是存在的）。导航栏设置为透明之后将无法接收到事件响应，用户事件会传递到导航栏的底部视图。
/// 将导航栏事件传递到底部视图层也符合导航栏被“隐藏”的行为。
@property (nonatomic, assign, readonly) BOOL nx_translucentNavigationBar;

/// 使导航栏内部的 `containerView ` 脱离 NXNavigationBar 单独存在。还会将 self.navigationController.navigationBar.userInteractionEnabled 属性设置为 NO。
/// 这样可以让 containerView 接收到事件响应方便开发者完全自定义导航栏的外观，containerView 的默认外边距为：UIEdgeInsetsMake(0, 8, 0, 8) ，
/// 可以使用 NXNavigationBar 的  `setContainerViewEdgeInsets:` 方法设置 containerView 的外边距。
/// 另外需要注意⚠️的是：导航栏返回按钮虽然无法接收用户的点击事件，但是还会显示在导航栏的上面，这样可以方便开发者在返回按钮底下添加自定义的返回按钮。
/// 如果你不需要显示这个返回按钮也可以通过 `nx_barTintColor` 属性设置返回按钮颜色为 [UIColor clearColor]
@property (nonatomic, assign, readonly) BOOL nx_containerViewWithoutNavigtionBar;

/// 是否开启返回按钮菜单，默认 `NO`。如果设置为 `YES`需要同时设置 NXNavigationBarAppearance 属性 `backButtonMenuSupported = YES`
@property (nonatomic, assign, readonly) BOOL nx_backButtonMenuEnabled API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos, tvos);

/// 设置触发全屏手势返回，离左边最大滑动距离
@property (nonatomic, assign) CGFloat nx_interactivePopMaxAllowedDistanceToLeftEdge;

/// 触发导航栏外观更新
- (void)nx_setNeedsNavigationBarAppearanceUpdate;

@end

NS_ASSUME_NONNULL_END
