//
//  ViewController09_FullScreenViewController09_FullScreen.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

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

- (UIColor *)nx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return self.randomColor;
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
