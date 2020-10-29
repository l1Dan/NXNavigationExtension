//
//  ViewController06_ShadowImage.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController06_ShadowImage.h"

@interface ViewController06_ShadowImage ()

@end

@implementation ViewController06_ShadowImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor whiteColor];
}

- (UIImage *)ue_shadowImage {
    return [UIImage imageNamed:@"NavigationBarShadowImage"];
}

@end
