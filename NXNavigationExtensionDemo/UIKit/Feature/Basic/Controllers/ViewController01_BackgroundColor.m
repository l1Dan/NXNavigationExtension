//
//  ViewController01_BackgroundColor.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController01_BackgroundColor.h"
#import "UIColor+RandomColor.h"

@interface ViewController01_BackgroundColor ()

@end

@implementation ViewController01_BackgroundColor

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)nx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return self.randomColor;
}

@end
