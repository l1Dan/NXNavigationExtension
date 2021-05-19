//
//  ViewController02_BackgroundImage.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <UNXNavigator/UNXNavigator.h>

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

- (UIColor *)unx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)unx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self unx_barTintColor]};
}

- (UIImage *)unx_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgorundImage;
}

@end
