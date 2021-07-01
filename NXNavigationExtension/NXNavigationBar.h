//
// NXNavigationBar.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NXNavigationExtensionInteractable <NSObject>

/// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
/// 执行 `nx_triggerSystemBackButtonHandler` 方法后也会触发以下回调
/// @param navigationController 当前使用的导航控制器
/// @param interactingGesture 是否为手势滑动返回
/// @return `YES` 表示不中断返回操作继续执行；`NO` 表示中断返回操作
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture;

@end

/// 全局外观设置
NS_SWIFT_NAME(NXNavigationBar.Appearance)
@interface NXNavigationBarAppearance : NSObject

/// 全局外观设置
@property (nonatomic, strong, class, readonly) NXNavigationBarAppearance *standardAppearance;

/// 自定义返回按钮
@property (nonatomic, strong, nullable) UIView *backButtonCustomView;

/// 设置返回按钮图片
@property (nonatomic, strong, nullable) UIImage *backImage;

/// 设置 NavigationBar 背景图片
@property (nonatomic, strong, nullable) UIImage *backgorundImage;

/// 设置 NavigationBar 底部阴影线条图片
@property (nonatomic, strong, nullable) UIImage *shadowImage;

/// 设置 NavigationBar tintColor （返回按钮颜色）
@property (nonatomic, strong) UIColor *tintColor;

/// 设置 NavigationBar 背景颜色
@property (nonatomic, strong) UIColor *backgorundColor;

@end

@interface NXNavigationBar : UIView

@property (nonatomic, strong, readonly) UIView *containerView;

/// NXNavigationBar 底部阴影
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;

/// NXNavigationBar 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// 模糊背景
@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

/// 设置 NXNavigationBar 模糊背景，背景穿透效果
/// @param enabled 是否使用模糊背景；默认 NO
- (void)enableBlurEffect:(BOOL)enabled;

/// 添加控件到 `containerView`
/// @param subview 子控件
- (void)addContainerViewSubview:(UIView *)subview;

/// 设置 `containerView` UIEdgeInsets
/// @param edgeInsets UIEdgeInsets；默认 UIEdgeInsetsMake(0, 8, 0, 8)
- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets;

/// 获取当前设置的皮肤
/// @param aClass UINavigationController 或子类类对象
+ (NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass;

/// 注册默认皮肤
/// @param aClass UINavigationController 或子类类对象
+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
