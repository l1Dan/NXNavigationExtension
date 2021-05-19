//
//  ViewController01_BackgroundColor.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <UNXNavigator/UNXNavigator.h>

#import "ViewController01_BackgroundColor.h"
#import "UIColor+RandomColor.h"

@interface ViewController01_BackgroundColor ()

@end

@implementation ViewController01_BackgroundColor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.largeTitleTextAttributes = [self unx_titleTextAttributes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)unx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)unx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self unx_barTintColor]};
}

- (UIColor *)unx_navigationBarBackgroundColor {
    return [UIColor customDarkGrayColor];
}

@end
