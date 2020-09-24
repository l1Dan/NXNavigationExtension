//
//  UINavigationController+UINavigationExtension.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UINavigationControllerCustomizable <NSObject>

/// 拦截：使用手势滑动返回或点击系统返回按钮时调用
/// @param navigationController 控制 `viewController` 跳转的导航控制器
/// @param usingGesture 返回的动作是否为手势滑动
/// @return 返回 YES 可以不中断继续 PopViewController，返回 NO 会中断返回
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewControllerUsingInteractivePopGesture:(BOOL)usingGesture;

@end

@interface UINavigationController (UINavigationExtension)

/// 全屏手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *ue_fullscreenPopGestureRecognizer;

/// 设置 UENavigationBar 是否可用；默认 YES；设置为 NO 时将使用系统导航栏
@property (nonatomic, assign) BOOL ue_useNavigationBar;

- (void)configureNavigationBar;

/// 跳到指定 ViewController，如果没有找到就创建一个新的 ViewController
/// @param className 需要跳转的 ViewController class
/// @param handler 调用创建 ViewController handler
- (void)ue_jumpViewControllerClass:(Class)className usingCreateViewControllerHandler:(__kindof UIViewController * (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
