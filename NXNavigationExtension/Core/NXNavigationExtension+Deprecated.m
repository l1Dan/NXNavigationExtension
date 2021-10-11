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

#import <objc/runtime.h>

#import "NXNavigationExtension+Deprecated.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"


@implementation NXNavigationBarAppearance (NXNavigationExtensionDeprecated)

+ (NXNavigationBarAppearance *)standardAppearance {
    return [[NXNavigationConfiguration alloc] init].navigationBarAppearance;
}

- (UIColor *)backgorundColor {
    return self.backgroundColor;
}

- (void)setBackgorundColor:(UIColor *)backgorundColor {
    self.backgroundColor = backgorundColor;
}

- (UIImage *)backgorundImage {
    return self.backgroundImage;
}

- (void)setBackgorundImage:(UIImage *)backgorundImage {
    self.backgroundImage = backgorundImage;
}

- (BOOL)isBackButtonMenuSupported {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number && [number isKindOfClass:[NSNumber class]]) {
        return [number boolValue];
    }
    return NO;
}

- (void)setBackButtonMenuSupported:(BOOL)backButtonMenuSupported {
    NSNumber *number = [NSNumber numberWithBool:backButtonMenuSupported];
    objc_setAssociatedObject(self, @selector(isBackButtonMenuSupported), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (backButtonMenuSupported) {
        self.backImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        self.landscapeBackImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    } else {
        self.backImageInsets = UIEdgeInsetsZero;
        self.landscapeBackImageInsets = UIEdgeInsetsZero;
    }
}

@end

@interface NXNavigationBar ()

@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@implementation NXNavigationBar (NXNavigationExtensionDeprecated)

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

- (void)enableBlurEffect:(BOOL)enabled {
    self.blurEffectEnabled = enabled;
}

+ (NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass {
    return [self appearanceFromRegisterNavigationControllerClass:aClass];
}

+ (NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass {
    if (aClass) {
        return [self appearanceFromRegisterNavigationController:[[aClass alloc] init]];
    }
    return nil;
}

+ (NXNavigationBarAppearance *)appearanceFromRegisterNavigationController:(__kindof UINavigationController *)navigationController {
    return [self configurationFromNavigationController:navigationController].navigationBarAppearance;
}

+ (NXNavigationConfiguration *)configurationRegisterFromNavigationController:(__kindof UINavigationController *)navigationController {
    return [self configurationFromNavigationController:navigationController];
}

+ (void)registerNavigationControllerClass:(Class)aClass {
    [self registerNavigationControllerClass:aClass withConfiguration:[[NXNavigationConfiguration alloc] init]];
}

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass {
    [self registerNavigationControllerClass:aClass forAppearance:[NXNavigationBarAppearance standardAppearance]];
}

+ (void)registerNavigationControllerClass:(Class)aClass forAppearance:(NXNavigationBarAppearance *)appearance {
    NXNavigationConfiguration *configuration = [[NXNavigationConfiguration alloc] init];
    configuration.navigationBarAppearance = appearance ?: [NXNavigationBarAppearance standardAppearance];
    [self registerNavigationControllerClass:aClass withConfiguration:configuration];
}

@end


@implementation UINavigationController (NXNavigationExtensionDeprecated)

+ (BOOL)nx_fullscreenPopGestureEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number && [number isKindOfClass:[NSNumber class]]) {
        return [number boolValue];
    }
    return NO;
}

+ (void)setNx_fullscreenPopGestureEnabled:(BOOL)nx_fullscreenPopGestureEnabled {
    NSNumber *number = [NSNumber numberWithBool:nx_fullscreenPopGestureEnabled];
    objc_setAssociatedObject(self, @selector(nx_fullscreenPopGestureEnabled), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nx_triggerSystemBackButtonHandler {
    [self nx_popViewControllerAnimated:YES];
}

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerBlock:(__kindof UIViewController * _Nullable (^)(void))block {
    [self nx_redirectViewControllerClass:aClass initializeStandbyViewControllerUsingBlock:block];
}

- (BOOL)nx_menuSupplementBackButton {
    return NO;
}

@end


@implementation UIViewController (NXNavigationExtensionDeprecated)

- (UIEdgeInsets)nx_backImageInsets {
    return self.navigationController.nx_backImageInsets;
}

- (UIEdgeInsets)nx_landscapeBackImageInsets {
    return self.navigationController.nx_landscapeBackImageInsets;}


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

- (BOOL)nx_backButtonMenuEnabled {
    return [self nx_useSystemBackButton];
}

@end
