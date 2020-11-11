//
//  DashboardTabBarController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/8.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "DashboardTabBarController.h"
#import "FeatureNavigationController.h"
#import "FeatureTableViewController.h"
#import "UIColor+RandomColor.h"

@interface DashboardTabBarController () <UITabBarControllerDelegate>

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UENavigationBarAppearance.standardAppearance.tintColor = [UIColor customDarkGrayColor];
    [UENavigationBar registerStandardAppearanceForNavigationControllerClass:[FeatureNavigationController class]];
    
    [UENavigationBar registerStandardAppearanceForNavigationControllerClass:[FeatureNavigationController class]];
    
    FeatureTableViewController *featureTableViewController1 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController1.navigationItem.title =  @"UENavigationBar 🎉 🎉 🎉";

    UIImage *customNormal = [UIImage imageNamed:@"TabBarCustomNormal"];
    UIImage *customSelected = [UIImage imageNamed:@"TabBarCustomSelected"];
    FeatureNavigationController *navigationController1 = [[FeatureNavigationController alloc] initWithRootViewController:featureTableViewController1];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UENavigationBar" image:customNormal selectedImage:customSelected];
    
    FeatureTableViewController *featureTableViewController2 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController2.navigationItem.title =  @"UINavigationBar⚠️⚠️⚠️";

    UIImage *systemNormal = [UIImage imageNamed:@"TabBarSystemNormal"];
    UIImage *systemSelected = [UIImage imageNamed:@"TabBarSystemSelected"];
    BaseNavigationController *navigationController2 = [[BaseNavigationController alloc] initWithRootViewController:featureTableViewController2];
    navigationController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UINavigationBar" image:systemNormal selectedImage:systemSelected];
    
    self.delegate = self;
    self.viewControllers = @[navigationController1, navigationController2];
    self.tabBar.tintColor = [UIColor customDarkGrayColor];
    self.tabBar.unselectedItemTintColor = [UIColor customLightGrayColor];
    
    // ⚠️Warning!!!
    navigationController2.view.layer.borderWidth = 3.0;
    navigationController2.view.layer.cornerRadius = 40;
    navigationController2.view.layer.borderColor = [UIColor redColor].CGColor;    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return;
    }
    
    NSMutableArray<__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:self.splitViewController.viewControllers];
    if ([viewController isMemberOfClass:[viewControllers.lastObject class]]) {
        return;
    }
    
    UINavigationController *oldDetailNavigationController = viewControllers.lastObject;
    UIViewController *contentViewController = [[[oldDetailNavigationController.viewControllers.lastObject class] alloc] init];
    UINavigationController *detailNavigationController =  [[[viewController class] alloc] initWithRootViewController:contentViewController];
    
    [viewControllers removeObject:oldDetailNavigationController];
    [viewControllers addObject:detailNavigationController];
    
    [self.splitViewController setViewControllers:viewControllers];
}

@end
