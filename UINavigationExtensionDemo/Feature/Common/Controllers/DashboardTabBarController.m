//
//  DashboardTabBarController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/8.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "DashboardTabBarController.h"
#import "FeatureNavigationController.h"
#import "UIColor+RandomColor.h"

@interface DashboardTabBarController ()

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UENavigationBar registerStandardAppearanceForNavigationControllerClass:[FeatureNavigationController class]];

    self.tabBar.tintColor = [UIColor customDarkGrayColor];
    self.tabBar.unselectedItemTintColor = [UIColor customLightGrayColor];
    
    UITabBarItem *lightItem = self.tabBar.items[0];
    lightItem.image = [[UIImage imageNamed:@"CustomNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lightItem.selectedImage = [[UIImage imageNamed:@"CustomSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *darkItem = self.tabBar.items[1];
    darkItem.image = [[UIImage imageNamed:@"SystemNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    darkItem.selectedImage = [[UIImage imageNamed:@"SystemSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // ⚠️Warning!!!
    UIViewController *systemNavigationController = self.viewControllers.lastObject;
    systemNavigationController.view.layer.borderWidth = 3.0;
    systemNavigationController.view.layer.cornerRadius = 40;
    systemNavigationController.view.layer.borderColor = [UIColor redColor].CGColor;
}

@end
