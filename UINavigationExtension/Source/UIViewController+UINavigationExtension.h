//
//  UIViewController+UINavigationExtension.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UENavigationBar;

/// 页面配置
@interface UIViewController (UINavigationExtension)

/// 获取 UENavigationBar
@property (nonatomic, strong, readonly) UENavigationBar *ue_navigationBar;

/// 设置 NavigationBar 背景颜色
@property (nonatomic, strong, readonly, nullable) UIColor *ue_navigationBarBackgroundColor;

/// 设置 NavigationBar 背景图片
@property (nonatomic, strong, readonly, nullable) UIImage *ue_navigationBarBackgroundImage;

/// 设置 NavigationBar barTintColor
@property (nonatomic, strong, readonly, nullable) UIColor *ue_barBarTintColor;

/// 设置 NavigationBar tintColor (可以返回按钮颜色)
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

/// 是否禁用滑动手势（边缘返回和全屏返回都不可用）；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_disableInteractivePopGesture;

/// 是否使用全屏返回；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_enableFullScreenInteractivePopGesture;

/// 是否自动隐藏 NavigationBar；默认 YES
@property (nonatomic, assign, readonly) BOOL ue_automaticallyHideNavigationBarInChildViewController;

/// 是否隐藏导航栏（UINavigationBar 和 UENavigationBar）都会隐藏；默认 NO
@property (nonatomic, assign, readonly) BOOL ue_hidesNavigationBar;

/// 设置触发全屏手势返回，离左边最大滑动距离
@property (nonatomic, assign) CGFloat ue_interactivePopMaxAllowedDistanceToLeftEdge;

/// 拦截点击返回按钮事件
- (void)ue_triggerSystemBackButtonHandle;

@end

NS_ASSUME_NONNULL_END
