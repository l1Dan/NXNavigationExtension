//
//  ViewController05_ShadowColor.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController05_ShadowColor.h"

@interface ViewController05_ShadowColor ()

@end

@implementation ViewController05_ShadowColor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)ue_shadowImageTintColor {
    return [UIColor redColor];
}

@end
