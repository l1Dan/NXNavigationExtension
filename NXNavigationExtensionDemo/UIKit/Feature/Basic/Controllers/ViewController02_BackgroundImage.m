//
//  ViewController02_BackgroundImage.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController02_BackgroundImage.h"
#import "UIImage+NavigationBar.h"

@interface ViewController02_BackgroundImage ()

@end

@implementation ViewController02_BackgroundImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)nx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

- (UIImage *)nx_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgroundImage;
}

@end
