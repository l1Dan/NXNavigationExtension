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
#import "AutoNavigationController.h"

@interface DashboardTabBarController ()

@end

@implementation DashboardTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UENavigationBarAppearance *lightAppearance = [UENavigationBarAppearance standardAppearance];
    [UENavigationBar registerAppearance:lightAppearance forNavigationControllerClass:[LightNavigationController class]];
    
    UENavigationBarAppearance *darkAppearance = [UENavigationBarAppearance standardAppearance];
    [UENavigationBar registerAppearance:darkAppearance forNavigationControllerClass:[DarkNavigationController class]];
    
    UENavigationBarAppearance *autoAppearance = [UENavigationBarAppearance standardAppearance];
    [UENavigationBar registerAppearance:autoAppearance forNavigationControllerClass:[AutoNavigationController class]];
    
    [LightNavigationController registerViewControllerClass:[UIViewController class] forNavigationBarClass:[UINavigationBar class]];
    
}

@end
