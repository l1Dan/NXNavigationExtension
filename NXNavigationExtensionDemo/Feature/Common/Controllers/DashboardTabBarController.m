//
//  DashboardTabBarController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/8.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "BaseNavigationController.h"
#import "DashboardTabBarController.h"
#import "FeatureTableViewController.h"

#import "UIColor+RandomColor.h"
#import "UIDevice+Additions.h"

@interface DashboardTabBarController () <UITabBarControllerDelegate>

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [NXNavigationConfiguration defaultConfiguration].navigationControllerPreferences.fullscreenInteractivePopGestureEnabled = YES;
    NXNavigationConfiguration *configuration = [[NXNavigationConfiguration alloc] init];
    configuration.navigationBarAppearance.tintColor = [UIColor customTitleColor];
    if (@available(iOS 14.0, *)) {
        configuration.navigationControllerPreferences.menuSupplementBackButton = YES;
    }
    [NXNavigationBar registerNavigationControllerClass:[FeatureNavigationController class] withConfiguration:configuration];
    
//    NXNavigationConfiguration *otherConfiguration = [[NXNavigationConfiguration alloc] init];
//    otherConfiguration.navigationBarAppearance.backgroundColor = [UIColor redColor];
//    if (@available(iOS 14.0, *)) {
//        otherConfiguration.navigationControllerPreferences.menuSupplementBackButton = YES;
//    }
//    [NXNavigationBar registerNavigationControllerClass:[OtherNavigationController class] withConfiguration:otherConfiguration];

    FeatureTableViewController *featureTableViewController1 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController1.navigationItem.title = @"NXNavigationBar🎉🎉🎉";

    UIImage *customNormal = [UIImage imageNamed:@"TabBarCustomNormal"];
    UIImage *customSelected = [UIImage imageNamed:@"TabBarCustomSelected"];
    FeatureNavigationController *navigationController1 = [[FeatureNavigationController alloc] initWithRootViewController:featureTableViewController1];
    navigationController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Custom" image:customNormal selectedImage:customSelected];
    
    FeatureTableViewController *featureTableViewController2 = [[FeatureTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    featureTableViewController2.navigationItem.title = @"UINavigationBar⚠️⚠️⚠️";

    UIImage *systemNormal = [UIImage imageNamed:@"TabBarSystemNormal"];
    UIImage *systemSelected = [UIImage imageNamed:@"TabBarSystemSelected"];
    OtherNavigationController *navigationController2 = [[OtherNavigationController alloc] initWithRootViewController:featureTableViewController2];
    navigationController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"System" image:systemNormal selectedImage:systemSelected];
    
    self.delegate = self;
    self.viewControllers = @[navigationController1, navigationController2];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        [tabBarAppearance configureWithDefaultBackground];
        tabBarAppearance.backgroundColor = [UIColor systemBackgroundColor];
        self.tabBar.standardAppearance = tabBarAppearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance;
        }
    }
    
    self.tabBar.tintColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor customDarkGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor customLightGrayColor];
    }];
    
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return [UIColor customLightGrayColor];
        } darkModeColor:^UIColor * _Nonnull{
            return [UIColor customDarkGrayColor];
        }];
    }
    
    self.tabBar.translucent = NO; // FIXED: iOS Modal -> Dismiss -> Push, TabBar BUG
    
    // ⚠️Warning!!!
    navigationController2.view.layer.borderWidth = 3.0;
    navigationController2.view.layer.cornerRadius = 40;
    navigationController2.view.layer.borderColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor orangeColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor orangeColor] colorWithAlphaComponent:0.5];
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
