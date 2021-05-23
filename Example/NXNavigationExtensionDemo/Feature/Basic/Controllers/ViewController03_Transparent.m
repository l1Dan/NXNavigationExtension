//
//  ViewController03_Transparent.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController03_Transparent.h"

@interface ViewController03_Transparent ()

@end

@implementation ViewController03_Transparent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
