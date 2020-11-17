//
//  ViewController01_BackgroundColor.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController01_BackgroundColor.h"
#import "UIColor+RandomColor.h"

@interface ViewController01_BackgroundColor ()

@end

@implementation ViewController01_BackgroundColor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.largeTitleTextAttributes = [self ue_titleTextAttributes];
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

- (UIColor *)ue_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self ue_barTintColor]};
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor customDarkGrayColor];
}

@end
