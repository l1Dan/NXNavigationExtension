//
// UINavigationController+UINavigationExtension.h
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

FOUNDATION_EXPORT BOOL UINavigationExtensionFullscreenPopGestureEnable;

@protocol UINavigationControllerCustomizable <NSObject>

/// 拦截：使用手势滑动返回或点击系统返回按钮时调用
/// UIViewController+UINavigationExtension.h (Method: ue_triggerSystemBackButtonHandle) 也会触发回调
/// @param navigationController 控制 `viewController` 跳转的导航控制器
/// @param usingGesture 返回的动作是否为手势滑动
/// @return 返回 YES 可以不中断继续 PopViewController，返回 NO 会中断返回
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewControllerUsingInteractivePopGesture:(BOOL)usingGesture;

@end

@interface UINavigationController (UINavigationExtension)

/// 设置 UENavigationBar 是否可用；默认 YES；设置为 NO 时将使用系统导航栏
@property (nonatomic, assign) BOOL ue_useNavigationBar;

/// 全屏手势 UIPanGestureRecognizer
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *ue_fullscreenPopGestureRecognizer;

/// 跳到指定 ViewController，如果没有找到就创建一个新的 ViewController
/// @param className 需要跳转的 ViewController class
/// @param handler 调用创建 ViewController handler
- (void)ue_jumpViewControllerClass:(Class)className usingCreateViewControllerHandler:(__kindof UIViewController * (^)(void))handler;

+ (void)registerViewControllerClass:(Class)firstClass forNavigationBarClass:(Class)secondClass;

@end

NS_ASSUME_NONNULL_END
