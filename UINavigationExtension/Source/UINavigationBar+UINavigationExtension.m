//
// UINavigationBar+UINavigationExtension.m
//
// Copyright (c) 2020 Leo Lee UINavigationExtension (https://github.com/l1Dan/UINavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    UINavigationExtensionUINavigationBarDidUpdateFrameHandler ue_didUpdateFrameHandler = self.ue_didUpdateFrameHandler;
    if (ue_didUpdateFrameHandler) {
        self.ue_didUpdateFrameHandler(self.frame);
    }
    [self ue_layoutSubviews];
}

#pragma mark - Getter & Setter
- (UINavigationExtensionUINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_didUpdateFrameHandler:(UINavigationExtensionUINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
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
