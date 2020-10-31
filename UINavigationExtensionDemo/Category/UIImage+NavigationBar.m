//
//  UIImage+NavigationBar.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "UIImage+NavigationBar.h"

@implementation UIImage (NavigationBar)

+ (UIImage *)navigationBarBackgorundImage {
    CGFloat statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    return statusBarHeight <= 20.0 ? [UIImage imageNamed:@"NavigationBarBackgound64"] : [UIImage imageNamed:@"NavigationBarBackgound88"];
}

@end
