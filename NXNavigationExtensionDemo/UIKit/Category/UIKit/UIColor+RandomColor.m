//
//  UIColor+RandomColor.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor {
    CGFloat red = ((arc4random() % 340) + 10) / 360.0;
    CGFloat green = ((arc4random() % 340) + 10) / 360.0;
    CGFloat blue = ((arc4random() % 340) + 10) / 360.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)randomLightColor {
    CGFloat hue = 0.0;
    CGFloat saturation = 0.0;
    CGFloat brightness = 0.0;
    CGFloat alpha = 0.0;

    [[self randomColor] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if (saturation > 0.5) {
        saturation -= arc4random() % 50 / 100.0;
    }
    
    if (brightness < 0.5) {
        brightness += arc4random() % 50 / 100.0;
    }
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor *)randomDarkColor {
    CGFloat hue = 0.0;
    CGFloat saturation = 0.0;
    CGFloat brightness = 0.0;
    CGFloat alpha = 0.0;

    [[self randomColor] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (saturation < 0.5) {
        saturation += arc4random() % 50 / 100.0;
    }

    if (brightness > 0.5) {
        brightness -= arc4random() % 50 / 100.0;
    }
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor *)customTitleColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; // ![UIColor blackColor]
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // ![UIColor whiteColor]
    }];
}

+ (UIColor *)customDarkGrayColor {
    return [UIColor colorWithRed:25 / 255.0 green:43 / 255.0 blue:67 / 255.0 alpha:1.0];
}

+ (UIColor *)customLightGrayColor {
    return [UIColor colorWithRed:167 / 255.0 green:167 / 255.0 blue:167 / 255.0 alpha:1.0];
}

+ (UIColor *)customGroupedBackgroundColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.0]; // [UIColor groupTableViewBackgroundColor];
    } darkModeColor:^UIColor * _Nonnull{
        if (@available(iOS 13.0, *)) {
            return [UIColor systemGroupedBackgroundColor];
        } else {
            return [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.0]; // [UIColor groupTableViewBackgroundColor];
        }
    }];
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

+ (UIColor *)customColorWithLightModeColor:(UIColor *(^)(void))lightModeColor darkModeColor:(UIColor *(^)(void))darkModeColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkModeColor();
            }
            return lightModeColor();
        }];
    }
    return lightModeColor();
}

@end
