//
//  UEConfiguration.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/22.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

inline static void UINavigationExtensionSwizzleMethod(Class className, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(className, swizzledSelector);
    
    BOOL isSuccess = class_addMethod(className, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isSuccess) {
        class_replaceMethod(className, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 全局配置
@interface UEConfiguration : NSObject

@property (nonatomic, strong, readonly, class) UEConfiguration *defaultConfiguration;

/// 自定义返回按钮
@property (nonatomic, strong, nullable) UIView *backButtonCustomView;

/// 设置返回按钮图片
@property (nonatomic, strong, nullable) UIImage *backImage;

/// 设置 NavigationBar 背景图片
@property (nonatomic, strong, nullable) UIImage *backgorundImage;

/// 设置 NavigationBar 底部阴影线条图片
@property (nonatomic, strong, nullable) UIImage *shadowImage;

/// 设置 NavigationBar tintColor
@property (nonatomic, strong) UIColor *tintColor;

/// 设置 NavigationBar 背景颜色
@property (nonatomic, strong) UIColor *backgorundColor;

/// 是否使用全屏手势
@property (nonatomic, assign, getter=isFullscreenPopGestureEnable) BOOL fullscreenPopGestureEnable;

/// 获取 NavigationBar 高度
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;

/// 颜色转图片
/// @param color 图片颜色
- (nullable UIImage *)imageFromColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
