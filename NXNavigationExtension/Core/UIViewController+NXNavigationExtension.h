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

/// For SwiftUI，拿到当前的 NXNavigationVirtualWrapperView
@property (nonatomic, weak, nullable) __kindof NXNavigationVirtualWrapperView *nx_navigationVirtualWrapperView API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0));

/// 获取当前视图控制器转场状态
@property (nonatomic, assign, readonly) NXNavigationTransitionState nx_navigationTransitionState;

/// 获取当前控制器的 NXNavigationBar
@property (nonatomic, strong, readonly, nullable) NXNavigationBar *nx_navigationBar;

/// 设置 NXNavigationBar 背景颜色，默认：[UIColor systemBlueColor]，这样处理能够快速辨别框架是否生效
@property (nonatomic, strong, readonly, nullable) UIColor *nx_navigationBarBackgroundColor;

/// 设置 NXNavigationBar 背景图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_navigationBarBackgroundImage;

/// 设置 UINavigationBar tintColor（返回按钮颜色），默认：iOS13 之前 [UIColor whiteColor]，iOS13及以后 [UIColor systemBackgroundColor]
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barTintColor;

/// 设置 UINavigationBar barTintColor
@property (nonatomic, strong, readonly, nullable) UIColor *nx_barBarTintColor;

/// 设置 UINavigationBar titleTextAttributes
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_titleTextAttributes;

/// 设置 UINavigationBar largeTitleTextAttributes
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *nx_largeTitleTextAttributes API_UNAVAILABLE(tvos);

/// 设置 NXNavigationBar 底部阴影图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_shadowImage;

/// 设置 NXNavigationBar 底部阴影颜色
@property (nonatomic, strong, readonly, nullable) UIColor *nx_shadowColor;

/// 设置返回按钮图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_backImage;

/// 设置横屏时显示的返回按钮图片
@property (nonatomic, strong, readonly, nullable) UIImage *nx_landscapeBackImage;

/// 自定义返回按钮
@property (nonatomic, strong, readonly, nullable) UIView *nx_backButtonCustomView;

/// 系统返回按钮的 2 种标题：1. 使用系统默认返回标题，2.自定义系统返回按钮标题(或者标题为空)；
/// 默认：空字符串（不显示标题）。如果返回 nil，则使用系统返回按钮自带的标题
@property (nonatomic, copy, readonly, nullable) NSString *nx_systemBackButtonTitle;

/// 设置返回按钮图片 `backImage` 的偏移量，默认：backImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign, readonly) UIEdgeInsets nx_backImageInsets;

/// 设置横屏时显示返回按钮图片 `landscapeBackImage` 的偏移量，默认：landscapeBackImageInsets = {0, -8, 0, 0}
@property (nonatomic, assign, readonly) UIEdgeInsets nx_landscapeBackImageInsets;

/// 是否使用系统返回按钮；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_useSystemBackButton;

/// 是否使用模糊导航栏模糊；默认 NO。需要设置 nx_navigationBarBackgroundColor 的 alpha 颜色通道才会有效果
/// 将 nx_navigationBarBackgroundColor 设置为 [UIColor clearColor]，可以实现类似系统导航栏的模糊效果
@property (nonatomic, assign, readonly) BOOL nx_useBlurNavigationBar;

/// 过期：是否禁用边缘滑动返回手势；默认 NO
/// 使用 `NXNavigationTransitionDelegate` 代理方法 `nx_navigationTransition:navigationBackAction:`替代
/// SwiftUI 使用 `useNXNavigationView(onBackActionHandler:)` 替代
@property (nonatomic, assign, readonly) BOOL nx_disableInteractivePopGesture;

/// 是否启用全屏返回；默认 NO
@property (nonatomic, assign, readonly) BOOL nx_enableFullScreenInteractivePopGesture;

/// 是否自动隐藏 childViewController 的 NavigationBar；默认 YES
@property (nonatomic, assign, readonly) BOOL nx_automaticallyHideNavigationBarInChildViewController;

/// 设置导航栏是否透明（类似导航栏隐藏的效果，当不是真正意思的隐藏）。不推荐直接设置系统导航栏的显示或隐藏。
/// 开启这个属性会将 self.navigationController.navigationBar.barTintColor/tintColor/titleTextAttributes/largeTitleTextAttributes 的颜色都设置为：[UIColor clearColor]
/// 还会将 self.navigationItem.titleView.hidden 属性设置为 `YES`，以及将 self.navigationController.navigationBar.userInteractionEnabled 属性设置为 `NO`，
/// 这样可以实现导航栏“看起来”被隐藏了。设置为透明之后导航栏区域将无法处理用户交互，底部的视图此时将会处理用户交互。
/// 将导航栏底部视图层接收到事件响应也符合导航栏被“隐藏”的行为。
@property (nonatomic, assign, readonly) BOOL nx_translucentNavigationBar;

/// 设置系统导航栏是否能够处理用户交互；默认 NO。如果需要 NXNavigationBar 可以处理用户交互，则需要设置这个属性为 `YES`。
@property (nonatomic, assign, readonly) BOOL nx_systemNavigationBarUserInteractionDisabled;

/// 设置全屏手势触发距离
@property (nonatomic, assign, readonly) CGFloat nx_interactivePopMaxAllowedDistanceToLeftEdge;

/// 手动触发导航栏外观更新
- (void)nx_setNeedsNavigationBarAppearanceUpdate;

@end


@interface UIViewController (NXNavigationExtensionTransition)

/// Pop 视图控制器的同时 Present 一个新的视图控制器
/// @param viewControllerToPresent 需要 Present 的视图控制器
/// @param animated 默认 YES
/// @param completion Present 动画完成时的回调
- (nullable UIViewController *)nx_popAndPresentViewController:(UIViewController *)viewControllerToPresent
                                                     animated:(BOOL)animated
                                                   completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popAndPresentViewController(_:animated:completion:));

/// Pop 视图控制器的同时 Present 一个新的视图控制器
/// @param viewController 需要 Pop 的视图控制器
/// @param viewControllerToPresent 需要 Present 的视图控制器
/// @param animated 默认 YES
/// @param completion Present 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                 andPresentViewController:(UIViewController *)viewControllerToPresent
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:andPresentViewController:animated:completion:));

/// Pop 视图控制器的同时 Present 一个新的视图控制器
/// @param viewControllerToPresent 需要 Present 的视图控制器
/// @param animated 默认 YES
/// @param completion Present 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootAndPresentViewController:(UIViewController *)viewControllerToPresent
                                                                               animated:(BOOL)animated
                                                                             completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToRootAndPresentViewController(_:animated:completion:));

@end

NS_ASSUME_NONNULL_END
