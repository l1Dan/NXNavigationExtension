//
//  DrawAnimationTransitionDelegate.h
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawAnimationTransitionDelegate : NSObject

- (void)setupDrawerWithViewController:(UIViewController *)viewController inView:(UIView *)view;

- (void)openDrawer;

- (void)closeDrawer;
@end

NS_ASSUME_NONNULL_END
