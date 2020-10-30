//
// UIViewController+UINavigationExtension.h
//
// Copyright (c) 2020 Leo Lee UINavigationExtension (https://github.com/l1Dan/UINavigationExtension)
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

@class UENavigationBar;

/// 页面配置
@interface UIViewController (UINavigationExtension)

/// 获取当前控制器 UENavigationBar
@property (nonatomic, strong, readonly) UENavigationBar *ue_navigationBar;

/// 设置 NavigationBar 背景颜色
@property (nonatomic, strong, readonly, nullable) UIColor *ue_navigationBarBackgroundColor;

/// 设置 NavigationBar 背景图片
@property (nonatomic, strong, readonly, nullable) UIImage *ue_navigationBarBackgroundImage;

/// 设置 NavigationBar barTintColor
@property (nonatomic, strong, readonly, nullable) UIColor *ue_barBarTintColor;

/// 设置 NavigationBar tintColor (可以设置返回按钮颜色)
@property (nonatomic, strong, readonly, nullable) UIColor *ue_barTintColor;

/// 设置 NavigationBar titleTextAttributes
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *ue_titleTextAttributes;

/// 设置 NavigationBar 底部阴影图片
@property (nonatomic, strong, readonly, nullable) UIImage *ue_shadowImage;

/// 设置返回按钮图片
@property (nonatomic, strong, readonly, nullable) UIImage *ue_backImage;

/// 设置 NavigationBar 底部阴影颜色
@property (nonatomic, strong, readonly, nullable) UIColor *ue_shadowImageTintColor;

/// 自定义返回按钮
@property (nonatomic, strong, readonly, nullable) UIView *ue_backButtonCustomView;

/// 是否使用系统模糊效果；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_useSystemBlurNavigationBar;

/// 是否禁用边缘滑动返回手势；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_disableInteractivePopGesture;

/// 是否使用全屏返回；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_enableFullScreenInteractivePopGesture;

/// 是否自动隐藏 NavigationBar；默认 YES
@property (nonatomic, assign, readonly) BOOL ue_automaticallyHideNavigationBarInChildViewController;

/// 是否隐藏导航栏（UINavigationBar 和 UENavigationBar 都会隐藏）；默认 NO
/// 注意⚠️：这里并不是真正的隐藏导航栏，只是将导航栏变成透明，设置返回按钮透明，导航栏的 item(s) 和 title(view)
/// 需要自己控制是否显示。这样做的目的是让导航栏下方的视图可以接收到 UIResponder 的事件传递
@property (nonatomic, assign, readonly) BOOL ue_hidesNavigationBar;

/// UENavigationBar containerView 特性；默认 NO
/// 1. containerView 可以接收点击事件；2. 可以不跟随导航栏的透明度变化而变化
/// 注意⚠️：返回按钮点击事件不可用，但是还是显示的，可以方便自定义返回事件
@property (nonatomic, assign, readonly) BOOL ue_enableContainerViewFeature;

/// 设置触发全屏手势返回，离左边最大滑动距离
@property (nonatomic, assign, readonly) CGFloat ue_interactivePopMaxAllowedDistanceToLeftEdge;

/// 更新导航栏外观
- (void)ue_setNeedsNavigationBarAppearanceUpdate;

@end

NS_ASSUME_NONNULL_END
