//
// NXNavigationExtensionPrivate.h
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

#import "NXNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^UINavigationBarDidUpdatePropertiesHandler)(UINavigationBar *navigationBar);

@class NXNavigationVirtualWrapperView, NXNavigationRouter;

/// 边缘返回手势代理对象
@interface NXScreenEdgePopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

/// 全屏滑动返回手势代理
@interface NXFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end


@interface NXNavigationBar ()

/// UIViewController 的 edgesForExtendedLayout 属性是否为 UIRectEdgeNone
@property (nonatomic, assign) BOOL edgesForExtendedLayoutEnabled;

/// 是否使用 NXNavigationBar 背景模糊效果；默认 NO
@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@interface NXViewControllerPreferences ()

/// 当前视图控制器的 traitCollection 对象
@property (nonatomic, strong) UITraitCollection *traitCollection;

@end


@interface UINavigationItem (NXNavigationExtensionPrivate)

/// 关联 navigationItem 所使用的 viewController，用于监听中途返回按钮被修改的情况
@property (nonatomic, weak, nullable) UIViewController *nx_viewController;

@end


@interface UIScrollView (NXNavigationExtensionPrivate)

/// UIViewController 中 scrollView 所引用的 NXNavigationBar
@property (nonatomic, strong, nullable) NXNavigationBar *nx_navigationBar;

@end


@interface UINavigationBar (NXNavigationExtensionPrivate)

/// UINavigatoinBar layoutSubviews 时调用
@property (nonatomic, copy, nullable) UINavigationBarDidUpdatePropertiesHandler nx_didUpdatePropertiesHandler;

/// 是否允许 UINavigationBar 接收到事件响应，如果 nx_userInteractionEnabled = NO，那么用户事件会被传递到导航栏的底部视图。
@property (nonatomic, assign) BOOL nx_userInteractionEnabled;

@end


@interface UINavigationController (NXNavigationExtensionPrivate)

/// 边缘返回手势代理对象
@property (nonatomic, strong, readonly) NXScreenEdgePopGestureRecognizerDelegate *nx_screenEdgePopGestureDelegate;

/// 全屏返回手势代理对象
@property (nonatomic, strong, readonly) NXFullscreenPopGestureRecognizerDelegate *nx_fullscreenPopGestureDelegate;

@property (nonatomic, strong, readonly) NXNavigationRouter *nx_navigationRouter API_AVAILABLE(ios(13.0));

/// 是否使用 NXNavigationBar，默认 NO；如果导航控制器没有注册则使用系统导航栏
@property (nonatomic, assign, readonly) BOOL nx_useNavigationBar;

/// 配置 NXNavigationBar
- (void)nx_configureNavigationBar;

/// 配置全屏返回手势
- (void)nx_configureFullscreenPopGesture;

/// 控制器返回页面统一跳转逻辑
/// @param destinationViewController 目标视图控制器
/// @param interactiveType 当前返回执行的交互方式
/// @param handler 处理跳转的回调
- (id)nx_triggerSystemPopViewController:(__kindof UIViewController *)destinationViewController
                        interactiveType:(NXNavigationInteractiveType)interactiveType
                                handler:(id (^)(UINavigationController *navigationController))handler;

/// 检查全屏返回手势是否可用
/// @param viewController 当前的视图控制器
- (BOOL)nx_checkFullscreenInteractivePopGestureEnabledWithViewController:(__kindof UIViewController *)viewController;

/// 调整系统返回按钮设置
/// @param currentViewController 当前需要调整系统返回按钮设置的视图控制器
/// @param previousViewControllers 不包括 `currentViewController` 前面的所有视图控制器
- (void)nx_adjustmentSystemBackButtonForViewController:(__kindof UIViewController *)currentViewController inViewControllers:(NSArray<__kindof UIViewController *> *)previousViewControllers;

/// 准备 Pop 视图控制器的最后检查。主要检查代理 `nx_navigationInteractDelegate` 和视图控制器是否有实现 `id<NXNavigationInteractable>` 代理逻辑。
/// @param currentViewController 当前所处的视图控制器
/// @param destinationViewController 需要 Pop 到的目标视图控制器
/// @param interactiveType 当前 Pop 视图控制器的的交互类型
- (BOOL)nx_viewController:(__kindof UIViewController *)currentViewController preparePopViewController:(__kindof UIViewController *)destinationViewController interactiveType:(NXNavigationInteractiveType)interactiveType;

@end


@interface UIViewController (NXNavigationExtensionPrivate)

/// For SwiftUI，返回页面时交互事件代理
@property (nonatomic, weak, nullable) id<NXNavigationInteractable> nx_navigationInteractDelegate;

/// For SwiftUI，拿到当前的 NXNavigationVirtualWrapperView。
@property (nonatomic, weak, nullable) NXNavigationVirtualWrapperView *nx_navigationVirtualWrapperView API_AVAILABLE(ios(13.0));

/// 标记 viewController 是否存在于 self.navigationController.viewControllers 中
/// 可以有效地减少 viewController 内部逻辑无效的方法调用
@property (nonatomic, assign) BOOL nx_navigationStackContained;

/// 获取当前导航控制器的配置
@property (nonatomic, strong, nullable) NXNavigationConfiguration *nx_configuration;

/// 即将应用配置到当前视图控制器的回调
@property (nonatomic, strong, nullable) NXNavigationPrepareConfigurationCallback nx_prepareConfigureViewControllerCallback;

/// 设置 UINavigationBarItem
/// @param navigationController 包含当前视图控制器的导航控制器
- (void)nx_configureNavigationBarWithNavigationController:(__kindof UINavigationController *)navigationController;

@end

NS_ASSUME_NONNULL_END
