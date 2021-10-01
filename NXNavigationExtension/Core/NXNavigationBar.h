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

@class NXNavigationConfiguration;
@interface NXNavigationBar : UIView

/// 设置 `contentView` 的外边距；默认 UIEdgeInsetsMake(0, 8, 0, 8)
@property (nonatomic, assign) UIEdgeInsets contentViewEdgeInsets;

/// 设置自定义导航栏内容
@property (nonatomic, strong, readonly) UIView *contentView;

/// NXNavigationBar 底部阴影
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;

/// NXNavigationBar 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// NXNavigationBar 模糊背景
@property (nonatomic, strong, readonly) UIVisualEffectView *backgroundEffectView;

/// 获取当前导航控制器注册的全局配置
/// @param navigationController 当前视图控制器的 navigationController
+ (nullable NXNavigationConfiguration *)configurationFromRegisterNavigationController:(__kindof UINavigationController *)navigationController;

/// 设置需要注册的导航控制器，默认 configuration 为 [NXNavigationConfiguration defaultConfiguration]
/// @param aClass UINavigationController 或子类类对象
+ (void)registerNavigationControllerClass:(Class)aClass;

/// 设置需要注册的导航控制器，并且设置导航栏的外观，默认 configuration 为 [NXNavigationConfiguration defaultConfiguration]
/// @param aClass UINavigationController 或子类类对象
/// @param configuration NXNavigationConfiguration 导航栏全局配置
+ (void)registerNavigationControllerClass:(Class)aClass withConfiguration:(nullable NXNavigationConfiguration *)configuration;

@end

NS_ASSUME_NONNULL_END
