//
//  ViewController04_Translucent.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController04_Translucent.h"
#import "UIColor+RandomColor.h"

@interface ViewController04_Translucent ()

@end

@implementation ViewController04_Translucent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)nx_useSystemBlurNavigationBar {
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
