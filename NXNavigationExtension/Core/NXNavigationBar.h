//
// NXNavigationBar.h
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

/// 返回页面使用的交互方式
/// `NXNavigationInteractiveTypeCallNXPopMethod` 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 回调方式
/// `NXNavigationInteractiveTypeBackButtonMenuAction` 需要设置 NXNavigationBarAppearance 属性 `backButtonMenuSupported = YES`
typedef NS_ENUM(NSUInteger, NXNavigationInteractiveType) {
    NXNavigationInteractiveTypeCallNXPopMethod,      // 调用 `nx_pop` 系列方法返回
    NXNavigationInteractiveTypeBackButtonAction,     // 点击返回按钮返回
    NXNavigationInteractiveTypeBackButtonMenuAction, // 长按返回按钮选择菜单返回
    NXNavigationInteractiveTypePopGestureRecognizer, // 使用手势交互返回
};

@protocol NXNavigationInteractable <NSObject>

/// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
/// 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法后也会触发这个代理回调
/// @param navigationController 当前使用的导航控制器
/// @param viewController 即将要 Pop 的视图控制器
/// @param interactiveType 返回页面使用的交互方式
/// @return `YES` 表示不中断返回操作继续执行；`NO` 表示中断返回操作
- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController willPopViewController:(__kindof UIViewController *)viewController interactiveType:(NXNavigationInteractiveType)interactiveType;

@optional

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture API_DEPRECATED("Use nx_navigationController:willPopViewController:interactiveType: instead.", ios(2.0, 2.0));

@end

API_DEPRECATED("Use NXNavigationInteractable protocol.", ios(2.0, 2.0)) @protocol NXNavigationExtensionInteractable <NSObject>

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture API_DEPRECATED("Use nx_navigationController:willPopViewController:interactiveType: instead.", ios(2.0, 2.0));

@end

/// 全局外观设置
NS_SWIFT_NAME(NXNavigationBar.Appearance) @interface NXNavigationBarAppearance : NSObject

/// 全局外观设置
@property (nonatomic, strong, class, readonly) NXNavigationBarAppearance *standardAppearance;

/// 自定义返回按钮
@property (nonatomic, strong, nullable) UIView *backButtonCustomView;

/// 设置返回按钮图片
@property (nonatomic, strong, nullable) UIImage *backImage;

/// 设置横屏时显示的返回按钮图片
@property (nonatomic, strong, nullable) UIImage *landscapeBackImage;

/// 设置 NXNavigationBar 背景图片
@property (nonatomic, strong, nullable) UIImage *backgorundImage;

/// 设置 NXNavigationBar 底部阴影线条图片
@property (nonatomic, strong, nullable) UIImage *shadowImage;

/// 设置 UINavigationBar tintColor （返回按钮颜色），默认：[UIColor systemBlueColor]
@property (nonatomic, strong) UIColor *tintColor;

/// 设置 NXNavigationBar 背景颜色，默认：iOS13 之前 [UIColor whiteColor]，iOS13及以后 [UIColor systemBackgroundColor]
@property (nonatomic, strong) UIColor *backgorundColor;

/// 设置返回按钮图片 `backImage` 的 insets，默认：UIEdgeInsetsZero
/// 当 `backButtonMenuSupported = YES` 时 backImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign) UIEdgeInsets backImageInsets;

/// 设置横屏时显示返回按钮图片 `landscapeBackImage` 的 insets，默认：UIEdgeInsetsZero
/// 当 `backButtonMenuSupported = YES` 时 landscapeBackImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign) UIEdgeInsets landscapeBackImageInsets;

/// 是否支持返回按钮菜单（iOS14 长按返回按钮会出现返回控制器列表）; 默认：NO
@property (nonatomic, assign, getter=isBackButtonMenuSupported) BOOL backButtonMenuSupported API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos, tvos);

@end


@interface NXNavigationBar : UIView

@property (nonatomic, strong, readonly) UIView *containerView;

/// NXNavigationBar 底部阴影
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;

/// NXNavigationBar 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// 模糊背景
@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

- (void)enableBlurEffect:(BOOL)enabled API_DEPRECATED("No longer supported; please adopt UIViewController nx_useBlurNavigationBar instead.", ios(2.0, 2.0));

/// 添加控件到 `containerView`
/// @param subview 子控件
- (void)addContainerViewSubview:(UIView *)subview;

/// 设置 `containerView` UIEdgeInsets
/// @param edgeInsets UIEdgeInsets；默认 UIEdgeInsetsMake(0, 8, 0, 8)
- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (nullable NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use appearanceFromRegisterNavigationControllerClass: instead.", ios(2.0, 2.0));

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use registerNavigationControllerClass:forAppearance: instead.", ios(2.0, 2.0));

/// 获取已经注册的导航控制器外观设置
/// @param aClass UINavigationController 或子类类对象
+ (nullable NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass;

/// 设置需要注册的导航控制器，并且设置导航栏的外观，如果 appearance == nil，则设置 appearance 为 [NXNavigationBarAppearance standardAppearance]
/// @param aClass UINavigationController 或子类类对象
/// @param appearance NXNavigationBarAppearance 导航栏外观
+ (void)registerNavigationControllerClass:(Class)aClass forAppearance:(nullable NXNavigationBarAppearance *)appearance;


@end

NS_ASSUME_NONNULL_END
