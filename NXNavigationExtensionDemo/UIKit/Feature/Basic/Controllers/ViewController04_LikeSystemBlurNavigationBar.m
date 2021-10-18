//
//  ViewController04_LikeSystemBlurNavigationBar.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController04_LikeSystemBlurNavigationBar.h"
#import "UIColor+RandomColor.h"

@interface ViewController04_LikeSystemBlurNavigationBar ()

@end

@implementation ViewController04_LikeSystemBlurNavigationBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIColor *)nx_navigationBarBackgroundColor {
//    return [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    return [UIColor clearColor];
}

- (BOOL)nx_useBlurNavigationBar {
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
