//
//  ViewController04_Translucent.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UNXNavigator/UNXNavigator.h>

#import "ViewController04_Translucent.h"
#import "UIColor+RandomColor.h"

@interface ViewController04_Translucent ()

@end

@implementation ViewController04_Translucent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)unx_useSystemBlurNavigationBar {
    return YES;
}

- (UIColor *)randomColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor randomLightColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor randomDarkColor];
    }];
}

@end
