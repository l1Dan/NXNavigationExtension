//
//  UINavigationBar+UINavigationExtension.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import "UINavigationBar+UINavigationExtension.h"
#import "UINavigationExtensionMacro.h"

@implementation UINavigationBar (UINavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UINavigationBar class], @selector(layoutSubviews), @selector(ue_layoutSubviews));
        UINavigationExtensionSwizzleMethod([UINavigationBar class], @selector(setUserInteractionEnabled:), @selector(ue_setUserInteractionEnabled:));
    });
}

- (void)ue_layoutSubviews {
    UINavigationBarDidUpdateFrameHandler ue_didUpdateFrameHandler = self.ue_didUpdateFrameHandler;
    if (ue_didUpdateFrameHandler) {
        self.ue_didUpdateFrameHandler(self.frame);
    }
    [self ue_layoutSubviews];
}

#pragma mark - Getter & Setter
- (UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_didUpdateFrameHandler:(UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    objc_setAssociatedObject(self, @selector(ue_didUpdateFrameHandler), ue_didUpdateFrameHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ue_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if (self.ue_userInteractionDisabled) {
        [self ue_setUserInteractionEnabled:NO];
        return;
    }
    [self ue_setUserInteractionEnabled:userInteractionEnabled];
}

- (BOOL)ue_userInteractionDisabled {
    NSNumber *userInteractionDisabled = objc_getAssociatedObject(self, _cmd);
    if (userInteractionDisabled && [userInteractionDisabled isKindOfClass:[NSNumber class]]) {
        return [userInteractionDisabled boolValue];
    }
    userInteractionDisabled = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, userInteractionDisabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [userInteractionDisabled boolValue];
}

- (void)setUe_userInteractionDisabled:(BOOL)ue_userInteractionDisabled {
    objc_setAssociatedObject(self, @selector(ue_userInteractionDisabled), [NSNumber numberWithBool:ue_userInteractionDisabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
