//
//  ViewController10_FullScreen.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UNXNavigator/UNXNavigator.h>

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

- (UIColor *)unx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)unx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self unx_barTintColor]};
}

- (UIColor *)unx_navigationBarBackgroundColor {
    return self.randomColor;
}

- (UIColor *)unx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
