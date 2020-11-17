//
//  ViewController10_FullScreen.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController09_FullScreen.h"

@interface ViewController09_FullScreen ()

@end

@implementation ViewController09_FullScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.randomColor;
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
    return self.randomColor;
}

- (UIColor *)ue_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
