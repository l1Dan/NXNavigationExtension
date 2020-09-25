//
//  UINavigationExtensionMacro.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/26.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/// 方法交换
/// @param className 交换方法的类名
/// @param originalSelector 原始交换方法
/// @param swizzledSelector 需要交换的方法
static inline void UINavigationExtensionSwizzleMethod(Class className, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(className, swizzledSelector);
    
    BOOL isSuccess = class_addMethod(className, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isSuccess) {
        class_replaceMethod(className, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 将颜色转换成图片
/// @param color UIColor
static inline UIImage * UINavigationExtensionImageFromColor(UIColor *color)
{
    CGSize size = CGSizeMake(1.0, 1.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 获取导航栏高度
static inline CGFloat UINavigationExtensionNavigationBarHeight()
{
    if (@available(iOS 11.0, *))
    {
        UIWindow *keyWindow = nil;
        for (UIWindow *window in UIApplication.sharedApplication.windows)
        {
            if (window.isKeyWindow)
            {
                keyWindow = window;
            }
        }
        CGFloat top = keyWindow.safeAreaInsets.top;
        return top > 20.0 ? 88.0 : 64.0;
    }
    return 64.0;
}
