//
// UINavigationController+UNXNavigator.h
//
// Copyright (c) 2021 Leo Lee UNXNavigator (https://github.com/l1Dan/UNXNavigator)
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

@protocol UNXNavigatorInteractable <NSObject>

/// 使用手势滑动返回或点击系统返回按钮过程中可以拦截或中断返回继而执行其他操作
/// 执行 `unx_triggerSystemBackButtonHandler` 方法后也会触发以下回调
/// @param navigationController 当前使用的导航控制器
/// @param interactingGesture 是否为手势滑动返回
/// @return `YES` 表示不中断返回操作继续执行；`NO` 表示中断返回操作
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture;

@end

@interface UINavigationController (UNXNavigator)

/// 开启全局全屏手势；默认为 NO
@property (nonatomic, assign, class) BOOL unx_fullscreenPopGestureEnabled;

/// 全屏手势 UIPanGestureRecognizer
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *unx_fullscreenPopGestureRecognizer;

/// 调用此方法可以触发调用 id<UNXNavigatorInteractable> 代理方法
/// 可以在自定义返回按钮中调用这个方法，便于统一处理手势滑动返回和自定义返回按钮点击返回的拦截操作
- (void)unx_triggerSystemBackButtonHandler;

/// 重定向视图控制器。可以跳转同一导航控制器下的任一视图控制器
/// 只会判断视图控制器实例对象的类型（`Class`）是否相同，而非判断视图控制器实例对象（`Instance`）相同
/// 查找规则是从栈（ViewControllers）前往后查找，如果没有找到则调用 `block`，`block == NULL` 或者 `return nil;` 重定向都不会生效
/// 执行操作之后调用 `popViewControllerAnimated:` 方法，就可以返回到指定视图控制器类型（`Class`）对应的实例中去
/// @param aClass 指定需要跳转的视图控制器类型
/// @param block 如果指定的视图控制器类型没有找到，则会使用回调来获取需要创建的视图控制器实例对象
- (void)unx_redirectViewControllerClass:(Class)aClass createViewControllerUsingBlock:(__kindof UIViewController * (^ __nullable)(void))block;

@end

NS_ASSUME_NONNULL_END
