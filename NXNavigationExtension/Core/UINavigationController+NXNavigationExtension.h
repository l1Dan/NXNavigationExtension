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

/// 处理视图控制器转场时的周期事件
typedef NS_ENUM(NSUInteger, NXNavigationAction) {
    NXNavigationActionUnspecified,   // 初始、各种动作的 completed 之后都会立即转入 unspecified 状态

    NXNavigationActionWillPush,      // push 方法被触发，但尚未进行真正的 push 动作
    NXNavigationActionDidPush,       // 系统的 push 已经执行完，viewControllers 已被刷新
    NXNavigationActionPushCancelled, // 系统的 push 被取消，还是停留在当前页面
    NXNavigationActionPushCompleted, // push 动画结束（如果没有动画，则在 did push 后立即进入 completed）

    NXNavigationActionWillPop,      // pop 方法被触发，但尚未进行真正的 pop 动作
    NXNavigationActionDidPop,       // 系统的 pop 已经执行完，viewControllers 已被刷新（注意可能有 pop 失败的情况）
    NXNavigationActionPopCancelled, // 系统的 pop 被取消，还是停留在当前页面
    NXNavigationActionPopCompleted, // pop 动画结束（如果没有动画，则在 did pop 后立即进入 completed）

    NXNavigationActionWillSet,      // setViewControllers 方法被触发，但尚未进行真正的 set 动作
    NXNavigationActionDidSet,       // 系统的 setViewControllers 已经执行完，viewControllers 已被刷新
    NXNavigationActionSetCancelled, // 系统的 setViewControllers 被取消，还是停留在当前页面
    NXNavigationActionSetCompleted, // setViewControllers 动画结束（如果没有动画，则在 did set 后立即进入 completed）
};

/// 返回页面使用的交互方式
/// `NXNavigationInteractiveTypeCallNXPopMethod` 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 回调方式
/// `NXNavigationInteractiveTypeBackButtonMenuAction` 需要设置 `useSystemBackButton = YES` 或者 `nx_useSystemBackButton = YES`
typedef NS_ENUM(NSUInteger, NXNavigationInteractiveType) {
    NXNavigationInteractiveTypeCallNXPopMethod,      // 调用 `nx_pop` 系列方法返回
    NXNavigationInteractiveTypeBackButtonAction,     // 点击返回按钮返回
    NXNavigationInteractiveTypeBackButtonMenuAction, // 长按返回按钮选择菜单返回
    NXNavigationInteractiveTypePopGestureRecognizer, // 使用手势交互返回
};

@protocol NXNavigationControllerDelegate <NSObject>

@optional

/// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作，某些业务场景中点击返回按钮或者手势滑动返回时需要弹框，可以直接使用这个代理拦截事件处理
/// 执行 `nx_popViewControllerAnimated:`、`nx_popToViewController:animated:` 或 `nx_popToRootViewControllerAnimated:` 等方法后也会触发这个代理回调
/// @param navigationController 当前使用的导航控制器
/// @param viewController 即将要 Pop 的视图控制器
/// @param interactiveType 返回页面使用的交互方式
/// @return `YES` 表示不中断返回操作继续执行；`NO` 表示中断返回操作
- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController
          willPopViewController:(__kindof UIViewController *)viewController
                interactiveType:(NXNavigationInteractiveType)interactiveType;

/// 处理视图控制器转场的周期事件
/// @param navigationController 当前使用的导航控制器
/// @param viewController 正在处理的视图控制器
/// @param navigationAction 当前转场周期实践
- (void)nx_navigationController:(__kindof UINavigationController *)navigationController
          processViewController:(__kindof UIViewController *)viewController
               navigationAction:(NXNavigationAction)navigationAction;

@end


@interface UINavigationController (NXNavigationExtension)

/// 全屏手势识别器
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *nx_fullScreenPopGestureRecognizer;

/// 即将应用配置到已经注册的导航控制器所管理的视图控制器的回调，每个视图控制器控实例对象只会调用一次。
/// @param callback 设置将要配置的信息
- (void)nx_prepareConfigureViewControllersCallback:(NXViewControllerPrepareConfigurationCallback)callback;

/// For SwiftUI，应用 NXNavigationVirtualWrapperView 实例对象的查找规则
- (void)nx_applyFilterNavigationVirtualWrapperViewRuleCallback:(NXNavigationVirtualWrapperViewFilterCallback)callback API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));

@end


@interface UINavigationController (NXNavigationExtensionTransition)

/// 调用 Push 视图控制器方法，并添加动画完成时的回调
/// @param viewController 需要 Push 的视图控制器
/// @param animated 默认 YES
/// @param completion Push 动画完成时的回调
- (void)nx_pushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^__nullable)(void))completion NS_SWIFT_ASYNC_NAME(nx_pushViewController(_:animated:));

/// 调用此方法可以触发调用 id<NXNavigationControllerDelegate> 代理方法
/// 可以统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
/// 内部最终会调用系统方法：`popViewControllerAnimated:`
/// @param animated 默认 YES
/// @param completion Pop 动画完成时的回调
- (nullable UIViewController *)nx_popViewControllerAnimated:(BOOL)animated
                                                 completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popViewController(animated:completion:));

/// 调用此方法可以触发调用 id<NXNavigationControllerDelegate> 代理方法
/// 可以统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
/// 内部最终会调用系统方法：`popToViewController:animated:`
/// @param viewController 需要 Pop 的视图控制器
/// @param animated 默认 YES
/// @param completion Pop 动画完成时的回调
- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:animated:completion:));

/// 调用此方法可以触发调用 id<NXNavigationControllerDelegate> 代理方法
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

/// 此特性针对 UINavigationController 中的 viewControllers 栈属性操作。
/// 主要处理当前页面的上一级页面该如何显示的问题，合理利用此特性能够增强使用手势滑动返回或者点击返回按钮返回页面时的体验。
/// 如果匹配到视图控制器的类型，则丢弃栈中其他的 ViewControllers 实例，没有匹配到则添加从 block 返回的 ViewController 实例到栈中。
/// @param aClass 需要匹配的 UIViewController 类型
/// @param block 如果目标 UIViewController 类型没有匹配到需要创建一个新的 UIViewController 实例
- (void)nx_setPreviousViewControllerWithClass:(Class)aClass
 insertsInstanceToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block;

@end

NS_ASSUME_NONNULL_END
