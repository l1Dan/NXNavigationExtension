//
//  ViewController05_ShadowColor.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController05_ShadowColor.h"

@interface ViewController05_ShadowColor ()

@end

@implementation ViewController05_ShadowColor

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor redColor];
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return self.view.backgroundColor;
}

@end
