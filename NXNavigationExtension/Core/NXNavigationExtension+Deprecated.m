//
// NXNavigationExtension+Deprecated.m
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import "NXNavigationExtension+Deprecated.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"

@interface NXNavigationBar ()

@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@implementation NXNavigationBar (NXNavigationExtensionDeprecated)

+ (NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *)appearanceInfo {
    static NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *appearanceInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearanceInfo = [NSMutableDictionary dictionary];
    });
    return appearanceInfo;
}

- (UIView *)containerView {
    return self.contentView;
}

- (UIVisualEffectView *)visualEffectView {
    return self.backgroundEffectView;
}

- (void)addContainerViewSubview:(UIView *)subview {
    if (subview != self.containerView) {
        [self.containerView addSubview:subview];
    }
}

- (UIEdgeInsets)containerViewEdgeInsets {
    return self.contentViewEdgeInsets;
}

- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets {
    self.contentViewEdgeInsets = edgeInsets;
}

+ (NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass {
    return [self appearanceFromRegisterNavigationControllerClass:aClass];
}

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass {
    [self registerNavigationControllerClass:aClass forAppearance:[NXNavigationBarAppearance standardAppearance]];
}

+ (NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass {
    if (aClass) {
        return [NXNavigationBar appearanceInfo][NSStringFromClass(aClass)];
    }
    return nil;
}

+ (void)registerNavigationControllerClass:(Class)aClass forAppearance:(NXNavigationBarAppearance *)appearance {
    NSAssert(aClass != nil, @"参数不能为空！");
    if (!aClass) return;
    
    [NXNavigationBar appearanceInfo][NSStringFromClass(aClass)] = appearance ?: [NXNavigationBarAppearance standardAppearance];
    [NXNavigationBar setAppearanceForNavigationControllerUsingBlock:^NXNavigationBarAppearance * _Nullable(__kindof UINavigationController * _Nonnull navigationController) {
        return [self appearanceFromRegisterNavigationControllerClass:[navigationController class]];
    }];
}

- (void)enableBlurEffect:(BOOL)enabled {
    self.blurEffectEnabled = enabled;
}

@end


@implementation UINavigationController (NXNavigationExtensionDeprecated)

- (void)nx_triggerSystemBackButtonHandler {
    [self nx_popViewControllerAnimated:YES];
}

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerBlock:(__kindof UIViewController * _Nullable (^)(void))block {
    [self nx_redirectViewControllerClass:aClass initializeStandbyViewControllerUsingBlock:block];
}

@end


@implementation UIViewController (NXNavigationExtensionDeprecated)

- (BOOL)nx_useSystemBlurNavigationBar {
    return [self nx_useBlurNavigationBar];
}

- (BOOL)nx_enableFullScreenInteractivePopGesture {
    return [self nx_enableFullscreenInteractivePopGesture];
}

- (BOOL)nx_hidesNavigationBar {
    return [self nx_translucentNavigationBar];
}

- (BOOL)nx_containerViewWithoutNavigtionBar {
    return [self nx_contentViewWithoutNavigtionBar];
}

@end
