//
//  BaseSplitViewController.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/11/12.
//

#import "BaseSplitViewController.h"
#import "DashboardTabBarController.h"
#import "ViewController01_BackgroundColor.h"
#import "FeatureNavigationController.h"

#import "TableViewSection.h"
#import "UIDevice+Additions.h"

@interface BaseSplitViewController ()

@end

@implementation BaseSplitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        DashboardTabBarController *tabBarController = [[DashboardTabBarController alloc] init];
        ViewController01_BackgroundColor *viewController = [[ViewController01_BackgroundColor alloc] init];
        viewController.navigationItem.title = TableViewSection.makeAllSections.firstObject.items.firstObject.title;
        self.viewControllers = @[tabBarController, [[FeatureNavigationController alloc] initWithRootViewController:viewController]];
    }
    return self;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return UIDevice.isPhoneDevice ? self.viewControllers.lastObject : nil;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return UIDevice.isPhoneDevice ? self.viewControllers.lastObject : nil;
}

@end
