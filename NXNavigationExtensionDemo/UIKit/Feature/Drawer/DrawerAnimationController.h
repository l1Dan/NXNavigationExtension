//
//  DrawerAnimationController.h
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawerAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL reverse;

@end


NS_ASSUME_NONNULL_END
