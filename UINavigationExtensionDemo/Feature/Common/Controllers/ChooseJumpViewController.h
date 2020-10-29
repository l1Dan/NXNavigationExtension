//
//  ChooseJumpViewController.h
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/30.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseJumpViewController : BaseViewController

+ (void)showViewControllerFromViewController:(__kindof UIViewController *)viewController
                         withViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
                           completionHandler:(void (^)(__kindof UIViewController * _Nullable selectedViewController))completionHandler;

@end

NS_ASSUME_NONNULL_END
