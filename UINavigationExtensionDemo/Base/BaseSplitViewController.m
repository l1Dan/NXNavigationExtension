//
//  BaseSplitViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/11/12.
//

#import "BaseSplitViewController.h"
#import "DashboardTabBarController.h"
#import "ViewController01_BackgroundColor.h"
#import "FeatureNavigationController.h"

@interface BaseSplitViewController ()

@end

@implementation BaseSplitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        DashboardTabBarController *tabBarController = [[DashboardTabBarController alloc] init];
        ViewController01_BackgroundColor *viewController = [[ViewController01_BackgroundColor alloc] init];
        self.viewControllers = @[tabBarController, [[FeatureNavigationController alloc] initWithRootViewController:viewController]];
    }
    return self;
}

@end
