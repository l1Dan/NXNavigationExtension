//
//  UINavigationController+UINavigationExtension.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UINavigationControllerCustomizable <NSObject>

/**
 当手势滑动或点击返回按钮时调用

 @param navigationController 当前导航控制器
 @param usingGesture 是否使用手势滑动：区分是手势滑动还是点击返回按钮
 @return 是否继续完成手势滑动或点击按钮操作
 */

/// 拦截：使用手势滑动返回或点击系统返回按钮时调用
/// @param navigationController 控制 `viewController` 跳转的导航控制器
/// @param viewController 将要调整的视图控制器
/// @param usingGesture 返回的动作是否为手势滑动
/// @return 返回 YES 可以不中断继续 PopViewController，返回 NO 会中断返回
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewController:(__kindof UIViewController *)viewController usingInteractivePopGesture:(BOOL)usingGesture;

@end

@interface UINavigationController (UINavigationExtension)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *ue_fullscreenPopGestureRecognizer;
@property (nonatomic, assign, getter=ue_useNavigationBar) BOOL ue_useNavigationBar;

- (void)configureNavigationBar;

@end

NS_ASSUME_NONNULL_END
