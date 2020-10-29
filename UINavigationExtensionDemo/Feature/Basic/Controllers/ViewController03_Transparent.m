//
//  ViewController03_Transparent.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController03_Transparent.h"

@interface ViewController03_Transparent ()

@end

@implementation ViewController03_Transparent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)ue_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
