//
//  UIColor+RandomColor.h
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RandomColor)

+ (UIColor *)randomLightColor;

+ (UIColor *)randomDarkColor;

+ (UIColor *)customTitleColor;

+ (UIColor *)customTextColor;

+ (UIColor *)customLightGrayColor;

+ (UIColor *)customDarkGrayColor;

+ (UIColor *)customBlueColor;

+ (UIColor *)customBackgroundColor;

+ (UIColor *)customGroupedBackgroundColor;

+ (UIColor *)mixColor1:(UIColor*)color1 color2:(UIColor *)color2 ratio:(CGFloat)ratio;

+ (UIColor *)customColorWithLightModeColor:(UIColor *(^)(void))lightModeColor darkModeColor:(UIColor *(^)(void))darkModeColor;

@end

NS_ASSUME_NONNULL_END
