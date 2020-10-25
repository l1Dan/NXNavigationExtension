//
//  DashboardTabBarController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/8.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "DashboardTabBarController.h"
#import "LightNavigationController.h"
#import "DarkNavigationController.h"

@interface DashboardTabBarController ()

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UENavigationBar registerStandardAppearanceForNavigationControllerClass:[LightNavigationController class]];
//    [UENavigationBar registerStandardAppearanceForNavigationControllerClass:[DarkNavigationController class]];
    
    self.tabBar.tintColor = [UIColor colorWithRed:25/255.0 green:43/255.0 blue:67/255.0 alpha:1.0];
    
    UITabBarItem *lightItem = self.tabBar.items[0];
    lightItem.image = [[UIImage imageNamed:@"Light-Normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    lightItem.selectedImage = [[UIImage imageNamed:@"Light-Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *darkItem = self.tabBar.items[1];
    darkItem.image = [[UIImage imageNamed:@"Dark-Normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    darkItem.selectedImage = [[UIImage imageNamed:@"Dark-Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
