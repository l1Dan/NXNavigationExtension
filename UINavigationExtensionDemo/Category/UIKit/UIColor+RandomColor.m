//
//  UIColor+RandomColor.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor {
    CGFloat hue = arc4random() % 256 / 256.0;
    CGFloat saturation = arc4random() % 128 / 256.0 + 0.5;
    CGFloat brightness = arc4random() % 128 / 256.0 + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor *)customDarkGrayColor {
    return [UIColor colorWithRed:25 / 255.0 green:43 / 255.0 blue:67 / 255.0 alpha:1.0];
}

+ (UIColor *)customLightGrayColor {
    return [UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167 / 255.0 alpha:1.0];
}

+ (UIColor *)customBlueColor {
    return [UIColor colorWithRed:0.0 green:122 / 255.0 blue:1.0 alpha:1.0]; // [UIColor systemBlueColor]
}

+ (UIColor *)customGroupedBackgroundColor {
    return [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.0]; // [UIColor groupTableViewBackgroundColor];
}

+ (UIColor *)mixColor1:(UIColor*)color1 color2:(UIColor *)color2 ratio:(CGFloat)ratio {
    if(ratio > 1) ratio = 1;
    
    const CGFloat *components1 = CGColorGetComponents(color1.CGColor);
    const CGFloat *components2 = CGColorGetComponents(color2.CGColor);
    
    CGFloat r = components1[0] * ratio + components2[0] * (1 - ratio);
    CGFloat g = components1[1] * ratio + components2[1] * (1 - ratio);
    CGFloat b = components1[2] * ratio + components2[2] * (1 - ratio);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
