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
@interface UIViewController (NXNavigationExtension)

/// 获取当前控制器的 NXNavigationBar
@property (nonatomic, strong, readonly, nullable) NXNavigationBar *nx_navigationBar;

/// The same as NXNavigationBarAppearance `backgroundColor` instance.
@property (nonatomic, strong, readonly, nullable) UIColor *nx_navigationBarBackgroundColor;

/// The same as NXNavigationBarAppearance `backgroundImage` instance.
@property (nonatomic, strong, readonly, nullable) UIImage *nx_navigationBarBackgroundImage;

/// The same as NXNavigationBarAppearance `tintColor` instance.
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barTintColor;

/// The same as NXNavigationBarAppearance `barTintColor` instance.
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barBarTintColor;

/// The same as NXNavigationBarAppearance `titleTextAttributes` instance.
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_titleTextAttributes;

/// The same as NXNavigationBarAppearance `largeTitleTextAttributes` instance.
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_largeTitleTextAttributes API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

/// The same as NXNavigationBarAppearance `shadowImage` instance.
@property (nonatomic, strong, readonly, nullable) UIImage *nx_shadowImage;

/// The same as NXNavigationBarAppearance `shadowColor` instance.
@property (nonatomic, strong, readonly, nullable) UIColor *nx_shadowImageTintColor;

/// The same as NXNavigationBarAppearance `backImage` instance.
@property (nonatomic, strong, readonly, nullable) UIImage *nx_backImage;

/// The same as NXNavigationBarAppearance `landscapeBackImage` instance.
@property (nonatomic, strong, readonly, nullable) UIImage *nx_landscapeBackImage;

/// The same as NXNavigationBarAppearance `backButtonCustomView` instance.
@property (nonatomic, strong, readonly, nullable) UIView *nx_backButtonCustomView;

/// The same as NXNavigationBarAppearance `systemBackButtonTitle` instance.
@property (nonatomic, copy, readonly, nullable) NSString *nx_systemBackButtonTitle;

/// The same as NXNavigationBarAppearance `backImageInsets` instance.
@property (nonatomic, assign, readonly) UIEdgeInsets nx_backImageInsets;

/// The same as NXNavigationBarAppearance `landscapeBackImageInsets` instance.
@property (nonatomic, assign, readonly) UIEdgeInsets nx_landscapeBackImageInsets;

/// The same as NXNavigationBarAppearance `useSystemBackButton` instance.
@property (nonatomic, assign, readonly) BOOL nx_useSystemBackButton;

/// The same as NXViewControllerPreferences `useBlurNavigationBar` instance.
@property (nonatomic, assign, readonly) BOOL nx_useBlurNavigationBar;

/// The same as NXViewControllerPreferences `disableInteractivePopGesture` instance.
@property (nonatomic, assign, readonly) BOOL nx_disableInteractivePopGesture;

/// The same as NXViewControllerPreferences `enableFullScreenInteractivePopGesture` instance.
@property (nonatomic, assign, readonly) BOOL nx_enableFullScreenInteractivePopGesture;

/// The same as NXViewControllerPreferences `automaticallyHideNavigationBarInChildViewController` instance.
@property (nonatomic, assign, readonly) BOOL nx_automaticallyHideNavigationBarInChildViewController;

/// The same as NXViewControllerPreferences `translucentNavigationBar` instance.
@property (nonatomic, assign, readonly) BOOL nx_translucentNavigationBar;

/// The same as NXViewControllerPreferences `contentViewWithoutNavigationBar` instance.
@property (nonatomic, assign, readonly) BOOL nx_contentViewWithoutNavigationBar;

/// The same as NXViewControllerPreferences `interactivePopMaxAllowedDistanceToLeftEdge` instance.
@property (nonatomic, assign, readonly) CGFloat nx_interactivePopMaxAllowedDistanceToLeftEdge;

/// 手动触发导航栏外观更新
- (void)nx_setNeedsNavigationBarAppearanceUpdate;

@end

NS_ASSUME_NONNULL_END
