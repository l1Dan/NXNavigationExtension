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
    });
}

- (void)ue_layoutSubviews {
    UINavigationBarDidUpdateFrameHandler ue_didUpdateFrameHandler = self.ue_didUpdateFrameHandler;
    if (ue_didUpdateFrameHandler) {
        self.ue_didUpdateFrameHandler(self.frame);
    }
    [self ue_layoutSubviews];
}

#pragma mark - Private
- (UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_didUpdateFrameHandler:(UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    objc_setAssociatedObject(self, @selector(ue_didUpdateFrameHandler), ue_didUpdateFrameHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
