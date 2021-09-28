//
//  BaseNavigationController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/29.
//

#import "BaseNavigationController.h"


@implementation BaseNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end


@implementation FeatureNavigationController

@end


@implementation OtherNavigationController

@end

