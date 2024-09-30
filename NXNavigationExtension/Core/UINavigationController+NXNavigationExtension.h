//
// UINavigationController+NXNavigationExtension.h
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

#if __has_include(<NXNavigationExtension/NXNavigationExtension.h>)

#import <NXNavigationExtension/NXNavigationConfiguration.h>

#else

#import "NXNavigationConfiguration.h"

#endif /* __has_include */

NS_ASSUME_NONNULL_BEGIN

/// 视图控制器转场状态
typedef NS_ENUM(NSUInteger, NXNavigationTransitionState) {
    NXNavigationTransitionStateUnspecified,   // 初始、各种动作的 completed 之后都会立即转入 unspecified 状态
    
    NXNavigationTransitionStateWillPush,      // push 方法被触发，但尚未进行真正的 push 动作
    NXNavigationTransitionStateDidPush,       // 系统的 push 已经执行完，viewControllers 已被刷新
    NXNavigationTransitionStatePushCancelled, // 系统的 push 被取消，还是停留在当前页面
    NXNavigationTransitionStatePushCompleted, // push 动画结束（如果没有动画，则在 did push 后立即进入 completed）
    
    NXNavigationTransitionStateWillPop,      // pop 方法被触发，但尚未进行真正的 pop 动作
    NXNavigationTransitionStateDidPop,       // 系统的 pop 已经执行完，viewControllers 已被刷新（注意可能有 pop 失败的情况）
    NXNavigationTransitionStatePopCancelled, // 系统的 pop 被取消，还是停留在当前页面
    NXNavigationTransitionStatePopCompleted, // pop 动画结束（如果没有动画，则在 did pop 后立即进入 completed）
    
    NXNavigationTransitionStateWillSet,      // setViewControllers 方法被触发，但尚未进行真正的 set 动作
    NXNavigationTransitionStateDidSet,       // 系统的 setViewControllers 已经执行完，viewControllers 已被刷新
    NXNavigationTransitionStateSetCancelled, // 系统的 setViewControllers 被取消，还是停留在当前页面
    NXNavigationTransitionStateSetCompleted, // setViewControllers 动画结束（如果没有动画，则在 did set 后立即进入 completed）
};

/// 视图控制器返回事件
typedef NS_ENUM(NSUInteger, NXNavigationBackAction) {
    NXNavigationBackActionCallingNXPopMethod,   // 调用 `nx_pop` 系列方法返回
    NXNavigationBackActionClickBackButton,      // 点击返回按钮
    NXNavigationBackActionClickBackButtonMenu,  // 长按返回按钮选择菜单返回；需要设置 `useSystemBackButton = YES` 或者 `nx_useSystemBackButton = YES`
    NXNavigationBackActionInteractionGesture,   // 使用交互手势
};


typedef void (^NXNavigationTransitionStateHandler) (UIViewController *, NXNavigationTransitionState);
typedef BOOL (^NXNavigationBackActionHandler) (UIViewController *, NXNavigationBackAction);

NS_SWIFT_UI_ACTOR
@protocol NXNavigationTransitionDelegate <NSObject>

@optional

/// 视图控制器转场状态
/// @param transitionViewController 转场视图控制器
/// @param state 视图控制器转场状态
- (void)nx_navigationTransition:(__kindof UIViewController *)transitionViewController
      navigationTransitionState:(NXNavigationTransitionState)state;

/// 拦截视图控制器返回操作
/// @param transitionViewController 转场视图控制器
/// @param action 试图控制器返回事件
/// @return `YES` 表示继续返回操作；`NO` 表示中断返回操作
- (BOOL)nx_navigationTransition:(__kindof UIViewController *)transitionViewController
           navigationBackAction:(NXNavigationBackAction)action;

@end


@interface UINavigationItem (NXNavigationExtension)

/// 处理视图控制器转场状态；优先调用 NXNavigationTransitionDelegate
/// 只有在 `UIViewController` 的 `init` 方法中设置属性才能拿到到完整的 `Push` 状态
@property (nonatomic, copy, nullable) NXNavigationTransitionStateHandler nx_transitionStateHandler;

/// 拦截视图控制器返回操作；优先调用 NXNavigationTransitionDelegate
@property (nonatomic, copy, nullable) NXNavigationBackActionHandler nx_backActionHandler;

@end


@interface UINavigationController (NXNavigationExtension)

/// 全屏手势识别器
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *nx_fullScreenPopGestureRecognizer;

/// 即将应用配置到已经注册的导航控制器所管理的视图控制器的回调，每个视图控制器控实例对象只会调用一次。
/// @param callback 设置将要配置的信息
- (void)nx_prepareConfigureViewControllersCallback:(NXViewControllerPrepareConfigurationCallback)callback;

/// For SwiftUI，应用 NXNavigationVirtualWrapperView 实例对象的查找规则
- (void)nx_applyFilterNavigationVirtualWrapperViewRuleCallback:(NXNavigationVirtualWrapperViewFilterCallback)callback API_AVAILABLE(macos(11.0), ios(14.0), watchos(7.0), tvos(14.0));

@end


@interface UINavigationController (NXNavigationExtensionTransition)

/// 调用 Push 视图控制器方法，并添加动画完成时的回调
/// @param viewController 需要 Push 的视图控制器
/// @param animated 默认 YES
/// @param completion Push 动画完成时的回调
- (void)nx_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^__nullable)(void))completion NS_SWIFT_ASYNC_NAME(nx_pushViewController(_:animated:));

/// 调用此方法可以触发调用 id<NXNavigationTransitionDelegate> 代理方法
/// 可以统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
/// 内部最终会调用系统方法：`popViewControllerAnimated:`
/// @param animated 默认 YES
/// @param completion Pop 动画完成时的回调
- (nullable UIViewController *)nx_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popViewController(animated:completion:));

/// 调用此方法可以触发调用 id<NXNavigationTransitionDelegate> 代理方法
/// 可以统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
/// 内部最终会调用系统方法：`popToViewController:animated:`
/// @param viewController 需要 Pop 的视图控制器
/// @param animated 默认 YES
/// @param completion Pop 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:animated:completion:));

/// 调用此方法可以触发调用 id<NXNavigationTransitionDelegate> 代理方法
/// 可以统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
/// 内部最终会调用系统方法：`popToRootViewControllerAnimated:`
/// @param animated 默认 YES
/// @param completion Pop 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerAnimated:(BOOL)animated
                                                                           completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToRootViewController(animated:completion:));

/// Pop 视图控制器的同时 Push 一个新的视图控制器
/// @param viewControllerToPush 需要 Push 的视图控制器
/// @param animated 默认 YES
/// @param completion Push 动画完成时的回调
- (nullable UIViewController *)nx_popAndPushViewController:(UIViewController *)viewControllerToPush
                                                  animated:(BOOL)animated
                                                completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popAndPushViewController(_:animated:completion:));

/// Pop 视图控制器的同时 Push 一个新的视图控制器
/// @param viewController 需要 Pop 的视图控制器
/// @param viewControllerToPush 需要 Push 的视图控制器
/// @param animated 默认 YES
/// @param completion Push 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                    andPushViewController:(UIViewController *)viewControllerToPush
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:andPushViewController:animated:completion:));

/// Pop 视图控制器的同时 Push 一个新的视图控制器
/// @param viewControllerToPush 需要 Push 的视图控制器
/// @param animated 默认 YES
/// @param completion Push 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootAndPushViewController:(UIViewController *)viewControllerToPush
                                                                            animated:(BOOL)animated
                                                                          completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToRootAndPushViewController(_:animated:completion:));

/// 设置 UINavigationController 的 viewControllers
/// @param viewControllers 需要设置的 viewControllers
/// @param animated 默认 YES
/// @param completion Set  viewControllers 动画完成时的回调
- (void)nx_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                     animated:(BOOL)animated
                   completion:(void (^__nullable)(void))completion NS_SWIFT_ASYNC_NAME(nx_setViewControllers(_:animated:));

@end

NS_ASSUME_NONNULL_END
