//
// NXNavigationMenuBackControl.h
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

/// iOS 14 系统可以长按返回按钮显示菜单功能，使用 `UIContextMenuInteraction` 实现此功能。
/// 使用方式为：1.可以通过 `UINavigationController.nx_globalBackButtonMenuEnabled` 开启全局返回按钮显示菜单功能；
/// 2.也可以通过 UIViewController nx_backButtonMenuEnabled instance，开启页面级别的返回按钮显示菜单功能。
@interface NXNavigationMenuBackControl : UIControl

/// Back button tintColor，back-arrow tintColor
@property (nonatomic, strong) UIColor *menuTintColor;

/// 设置 Back button menu 需要显示的列表
/// @param viewControllers UINavigationControler viewControllers，如果最后一个控制器
/// 跟当前控制器一致，则需要移除之后才能正确显示返回按钮菜单列表，如果 viewControllers.count == 0
/// 则 NXNavigationMenuBackControl instance `contextMenuInteractionEnabled` 设置为 `NO`。
- (void)setViewControllers:(nullable NSArray<__kindof UIViewController *> *)viewControllers;

/// 返回按钮图片 back-arrow image，
/// 默认：[NXNavigationBarAppearance standardAppearance].backImage 或 viewController nx_backImage instance。
/// @param image 返回按钮需要显示的图片
- (instancetype)initWithImage:(UIImage *)image;

/// 自定义返回按钮，默认：nil 或 viewController nx_backButtonCustomView instance。
/// @param customView 自定义返回按钮
- (instancetype)initWithCustomView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
