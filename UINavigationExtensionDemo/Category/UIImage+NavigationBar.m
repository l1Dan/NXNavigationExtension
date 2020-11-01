//
//  UIImage+NavigationBar.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/25.
//

#import "UIImage+NavigationBar.h"

@implementation UIImage (NavigationBar)

+ (UIImage *)navigationBarBackgorundImage {
    CGFloat statusBarHeight = 20.0;
    
    __kindof UIWindow *keyWindow = UIApplication.sharedApplication.windows.firstObject;
    for (__kindof UIWindow *window in UIApplication.sharedApplication.windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
        }
    }
    
#if TARGET_OS_MACCATALYST
    statusBarHeight = CGRectGetHeight(keyWindow.windowScene.statusBarManager.statusBarFrame);
#else
    if (@available(iOS 13.0, *)) {
        statusBarHeight = CGRectGetHeight(keyWindow.windowScene.statusBarManager.statusBarFrame);
    } else {
        statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    }
#endif
    return statusBarHeight <= 20.0 ? [UIImage imageNamed:@"NavigationBarBackgound64"] : [UIImage imageNamed:@"NavigationBarBackgound88"];
}

@end
