//
//  BaseNavigationController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/29.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "BaseNavigationController.h"


@implementation BaseNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (void)dealloc {
    NSLog(@"Dealloced: %@", NSStringFromClass([self class]));
}

@end


@implementation FeatureNavigationController

@end


@implementation OtherNavigationController

@end

