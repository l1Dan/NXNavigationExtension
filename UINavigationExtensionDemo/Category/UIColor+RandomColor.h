//
//  UIColor+RandomColor.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RandomColor)

+ (UIColor *)randomColor;

+ (UIColor *)customLightGrayColor;

+ (UIColor *)customDarkGrayColor;

+ (UIColor *)customBlueColor;

+ (UIColor *)customGroupedBackgroundColor;

+ (UIColor *)mixColor1:(UIColor*)color1 color2:(UIColor *)color2 ratio:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END
