//
//  DashboardTabBarController.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/8.
//

#import <UNXNavigator/UNXNavigator.h>

#import "DashboardTabBarController.h"
#import "FeatureNavigationController.h"
#import "FeatureTableViewController.h"

#import "UIColor+RandomColor.h"
#import "UIDevice+Additions.h"

@interface DashboardTabBarController () <UITabBarControllerDelegate>

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UNXNavigationBarAppearance.standardAppearance.tintColor = [UIColor customTitleColor];
    [UNXNavigationBar registerStandardAppearanceForNavigationControllerClass:[FeatureNavigationController class]];
    
    FeatureTableViewController *featureTableViewController1 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController1.navigationItem.title = @"UNXNavigationBar 🎉 🎉 🎉";

    UIImage *customNormal = [UIImage imageNamed:@"TabBarCustomNormal"];
    UIImage *customSelected = [UIImage imageNamed:@"TabBarCustomSelected"];
    FeatureNavigationController *navigationController1 = [[FeatureNavigationController alloc] initWithRootViewController:featureTableViewController1];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UNXNavigationBar" image:customNormal selectedImage:customSelected];
    
    FeatureTableViewController *featureTableViewController2 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController2.navigationItem.title = @"UINavigationBar⚠️⚠️⚠️";

    UIImage *systemNormal = [UIImage imageNamed:@"TabBarSystemNormal"];
    UIImage *systemSelected = [UIImage imageNamed:@"TabBarSystemSelected"];
    BaseNavigationController *navigationController2 = [[BaseNavigationController alloc] initWithRootViewController:featureTableViewController2];
    navigationController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UINavigationBar" image:systemNormal selectedImage:systemSelected];
    
    self.delegate = self;
    self.viewControllers = @[navigationController1, navigationController2];
    
    self.tabBar.tintColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor customDarkGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor customLightGrayColor];
    }];
    
    self.tabBar.unselectedItemTintColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor customLightGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor customDarkGrayColor];
    }];
    
    self.tabBar.translucent = NO; // FIXED: iOS Modal -> Dismiss -> Push, TabBar BUG
    
    // ⚠️Warning!!!
    navigationController2.view.layer.borderWidth = 3.0;
    navigationController2.view.layer.cornerRadius = 40;
    navigationController2.view.layer.borderColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor redColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor redColor] colorWithAlphaComponent:0.5];
    }].CGColor;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (UIDevice.isPhoneDevice) return;
    
    NSMutableArray<__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:self.splitViewController.viewControllers];
    if ([viewController isMemberOfClass:[viewControllers.lastObject class]]) {
        return;
    }
    
    UINavigationController *oldDetailNavigationController = viewControllers.lastObject;
    UIViewController *oldDetailViewController = oldDetailNavigationController.viewControllers.lastObject;
    
    UIViewController *detailViewController = [[[oldDetailViewController class] alloc] init];
    detailViewController.navigationItem.title = oldDetailViewController.navigationItem.title;
    UINavigationController *detailNavigationController = [[[viewController class] alloc] initWithRootViewController:detailViewController];
    
    [viewControllers removeObject:oldDetailNavigationController];
    [viewControllers addObject:detailNavigationController];
    
    [self.splitViewController setViewControllers:viewControllers];
}

@end
