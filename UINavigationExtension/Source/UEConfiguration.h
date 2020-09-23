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

@interface UEConfiguration : NSObject

@property (nonatomic, strong, readonly, class) UEConfiguration *defaultConfiguration;
@property (nonatomic, strong, nullable) UIView *backButtonCustomView;
@property (nonatomic, strong, nullable) UIImage *backImage;
@property (nonatomic, strong, nullable) UIImage *backgorundImage;
@property (nonatomic, strong, nullable) UIImage *shadowImage;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *backgorundColor;

@property (nonatomic, assign, getter=isFullscreenPopGestureEnable) BOOL fullscreenPopGestureEnable;
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;

- (nullable UIImage *)imageFromColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
