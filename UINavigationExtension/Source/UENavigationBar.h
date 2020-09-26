//
// UENavigationBar.h
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

/// 全局外观设置
@interface UENavigationBarAppearance : NSObject

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

@interface UENavigationBar : UIView

@property (nonatomic, strong, readonly) UIView *containerView;

/// UENavigationBar 底部阴影
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;

/// UENavigationBar 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// 模糊背景
@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

/// 全局外观设置
@property (nonatomic, strong, class, readonly) UENavigationBarAppearance *standardAppearance;

/// 设置 UENavigationBar 模糊背景，背景穿透效果
/// @param enabled 是否使用模糊背景；默认 NO
- (void)enableBlurEffect:(BOOL)enabled;

/// 添加控件
/// @param view 子控件
- (void)addContainerSubview:(UIView *)view;

/// 设置 Container View UIEdgeInsets
/// @param edgeInsets UIEdgeInsets；默认 UIEdgeInsetsMake(0, 8, 0, 8)
- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
