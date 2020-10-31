//
//  HierarchyViewController.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HierarchyViewController : BaseViewController

+ (void)showFromViewController:(__kindof UIViewController *)viewController
           withViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
             completionHandler:(void (^)(__kindof UIViewController * _Nullable selectedViewController))completionHandler;

@end

NS_ASSUME_NONNULL_END
