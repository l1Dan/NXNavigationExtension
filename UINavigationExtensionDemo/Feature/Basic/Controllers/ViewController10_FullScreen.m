//
//  ViewController10_FullScreen.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController10_FullScreen.h"

@interface ViewController10_FullScreen ()

@end

@implementation ViewController10_FullScreen

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)ue_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return self.randomColor;
}

@end
