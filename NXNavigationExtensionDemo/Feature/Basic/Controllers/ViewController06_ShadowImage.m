//
//  ViewController06_ShadowImage.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController06_ShadowImage.h"

@interface ViewController06_ShadowImage ()

@end

@implementation ViewController06_ShadowImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIImage *)nx_shadowImage {
    return [UIImage imageNamed:@"NavigationBarShadowImage"];
}

@end
