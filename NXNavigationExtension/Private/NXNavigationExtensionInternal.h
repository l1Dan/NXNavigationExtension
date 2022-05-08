//
// NXNavigationExtensionInternal.h
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

#import <UINavigationController+NXNavigationExtension.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UINavigationBarDidUpdatePropertiesHandler)(UINavigationBar *navigationBar);

typedef void (^UIViewControllerDidUpdateFrameHandler)(UIViewController *viewController);


@class NXNavigationBar, NXNavigationVirtualWrapperView, NXNavigationRouter;

/// 边缘返回手势代理对象
@interface NXScreenEdgePopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end

/// 全屏滑动返回手势代理
@interface NXFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

/// 获取当前导航控制器
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/// 初始化方法
/// @param navigationController 当前导航控制器
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end


@interface NXNavigationObservationDelegate : NSObject

/// UIViewController view frame 改变时的回调
@property (nonatomic, copy) UIViewControllerDidUpdateFrameHandler viewControllerDidUpdateFrameHandler;

/// 当前 viewController
@property (nonatomic, weak, nullable, readonly) __kindof UIViewController *observe;

/// 便利构造函数
/// @param observe 当前 viewController
- (instancetype)initWithObserve:(UIViewController *)observe;

@end


@interface UINavigationItem (NXNavigationExtensionInternal)

/// 关联 navigationItem 所使用的 viewController，用于监听中途返回按钮被修改的情况
@property (nonatomic, weak, nullable) UIViewController *nx_viewController;

@end


@interface UIScrollView (NXNavigationExtensionInternal)

/// UIViewController 中 scrollView 所引用的 NXNavigationBar
@property (nonatomic, strong, nullable) NXNavigationBar *nx_navigationBar;

@end


@interface UINavigationBar (NXNavigationExtensionInternal)

/// UINavigationBar layoutSubviews 时调用
@property (nonatomic, copy, nullable) UINavigationBarDidUpdatePropertiesHandler nx_didUpdatePropertiesHandler;

/// 是否允许 UINavigationBar 接收到事件响应，如果 nx_userInteractionEnabled = NO，那么用户事件会被传递到导航栏的底部视图。
@property (nonatomic, assign) BOOL nx_userInteractionEnabled;

@end


@interface UINavigationController (NXNavigationExtensionInternal)

/// For SwiftUI，应用筛选 NXNavigationVirtualWrapperView 实例对象查找规则
@property (nonatomic, copy, nullable) NXNavigationVirtualWrapperViewFilterCallback nx_filterNavigationVirtualWrapperViewCallback API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

/// 边缘返回手势代理对象
@property (nonatomic, strong, readonly) NXScreenEdgePopGestureRecognizerDelegate *nx_screenEdgePopGestureDelegate;

/// 全屏返回手势代理对象
@property (nonatomic, strong, readonly) NXFullScreenPopGestureRecognizerDelegate *nx_fullScreenPopGestureDelegate;

/// For SwiftUI，保存 NXNavigationRouter 的实例对象。可以保持 UINavigationController 实例和 NXNavigationRouter 实例的对应关系
@property (nonatomic, strong, readonly) NXNavigationRouter *nx_navigationRouter API_AVAILABLE(ios(13.0));

/// 是否使用 NXNavigationBar，默认 NO；如果导航控制器没有注册则使用系统导航栏
@property (nonatomic, assign, readonly) BOOL nx_useNavigationBar;

/// 配置 NXNavigationBar
- (void)nx_configureNavigationBar;

/// 配置返回手势
- (void)nx_configureInteractivePopGestureRecognizerWithViewController:(__kindof UIViewController *)viewController;

/// 控制器返回页面统一跳转逻辑
/// @param destinationViewController 目标视图控制器
/// @param interactiveType 当前返回执行的交互方式
/// @param completion 转场动画完成或取消后的回调
/// @param handler 处理跳转的回调
- (id)nx_triggerSystemPopViewController:(__kindof UIViewController *)destinationViewController
                        interactiveType:(NXNavigationInteractiveType)interactiveType
   animateAlongsideTransitionCompletion:(void (^__nullable)(void))completion
                                handler:(id (^)(UINavigationController *navigationController))handler;

/// 调整系统返回按钮设置
/// @param currentViewController 当前需要调整系统返回按钮设置的视图控制器
/// @param previousViewControllers 不包括 `currentViewController` 前面的所有视图控制器
- (void)nx_adjustmentSystemBackButtonForViewController:(__kindof UIViewController *)currentViewController
                                     inViewControllers:(NSArray<__kindof UIViewController *> *)previousViewControllers;

/// 准备 Pop 视图控制器的最后检查。主要检查代理 `nx_navigationInteractDelegate` 和视图控制器是否有实现 `id<NXNavigationControllerDelegate>` 代理逻辑。
/// @param currentViewController 当前所处的视图控制器
/// @param destinationViewController 需要 Pop 到的目标视图控制器
/// @param interactiveType 当前 Pop 视图控制器的的交互类型
- (BOOL)nx_viewController:(__kindof UIViewController *)currentViewController
    preparePopViewController:(__kindof UIViewController *)destinationViewController
             interactiveType:(NXNavigationInteractiveType)interactiveType;

/// 处理即将显示的视图控制器的转场周期事件
/// @param appearingViewController 即将显示的视图控制器
/// @param navigationAction 当前视图控制器的转场周期事件
- (void)nx_processViewController:(__kindof UIViewController *)appearingViewController
                navigationAction:(NXNavigationAction)navigationAction;

@end


@interface UIViewController (NXNavigationExtensionInternal)

/// 获取当前视图控制器转场周期事件
@property (nonatomic, assign) NXNavigationAction nx_navigationAction;

/// 记录当前视图控制器是否为导航控制器的 rootViewController
@property (nonatomic, assign) BOOL nx_isRootViewController;

/// 记录是否为 childViewControllers 中的控制器，并且当前控制器不是 UINavigationController 的情况下。
@property (nonatomic, assign) BOOL nx_isChildViewController;

/// For SwiftUI，返回页面时交互事件代理
@property (nonatomic, weak, nullable) id<NXNavigationControllerDelegate> nx_navigationControllerDelegate;

/// 获取当前导航控制器的配置
@property (nonatomic, strong, nullable) NXNavigationConfiguration *nx_configuration;

/// 即将应用配置到当前视图控制器的回调，每个视图控制器控实例对象只会调用一次。
@property (nonatomic, strong, nullable) NXViewControllerPrepareConfigurationCallback nx_prepareConfigureViewControllerCallback;

/// 设置 UINavigationBarItem
/// @param navigationController 包含当前视图控制器的导航控制器
- (void)nx_configureNavigationBarWithNavigationController:(__kindof UINavigationController *)navigationController;

/// 可用于对  View 执行一些操作， 如果此时处于转场过渡中，这些操作会跟随转场进度以动画的形式展示过程
/// 如果处于非转场过程中，也会执行 animation ，随后执行 completion，业务无需关心是否处于转场过程中。
/// @param animation 要执行的操作
/// @param completion 转场动画完成或取消后的回调
- (void)nx_animateAlongsideTransition:(void (^__nullable)(id<UIViewControllerTransitionCoordinatorContext> context))animation
                           completion:(void (^__nullable)(id<UIViewControllerTransitionCoordinatorContext> context))completion;

@end

NS_ASSUME_NONNULL_END
