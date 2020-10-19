//
// UIViewController+UINavigationExtension.m
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

#import <objc/runtime.h>

#import "UENavigationBar.h"
#import "UINavigationController+UINavigationExtension.h"
#import "UINavigationExtensionMacro.h"
#import "UINavigationExtensionPrivate.h"

@interface UIViewController (UINavigationExtension)

@property (nonatomic, assign) BOOL ue_viewWillDisappearFinished;
@property (nonatomic, assign) BOOL ue_navigationBarInitFinished;

@end

@implementation UIViewController (UINavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UIViewController class], @selector(viewDidLoad), @selector(ue_viewDidLoad));
        UINavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillAppear:), @selector(ue_viewWillAppear:));
        UINavigationExtensionSwizzleMethod([UIViewController class], @selector(viewDidAppear:), @selector(ue_viewDidAppear:));
        UINavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillDisappear:), @selector(ue_viewWillDisappear:));
        UINavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillLayoutSubviews), @selector(ue_viewWillLayoutSubviews));
    });
}

- (void)ue_viewDidLoad {
    self.ue_navigationBarInitFinished = NO;
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        self.ue_navigationBarInitFinished = YES;
        
        [self.navigationController ue_configureNavigationBar];
        [self updateNavigationBarAppearance];
    }
    
    [self ue_viewDidLoad];
}

- (void)ue_viewWillAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        if (!self.ue_navigationBarInitFinished) {
            // FIXED: 修复 viewDidLoad 调用时，界面还没有显示无法获取到 navigationController 对象问题
            [self.navigationController ue_configureNavigationBar];
            [self updateNavigationBarAppearance];
        }
        
        self.navigationController.navigationBar.barTintColor = self.ue_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.ue_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.ue_titleTextAttributes;
        
        __weak typeof(self) weakSelf = self;
        self.navigationController.navigationBar.ue_didUpdateFrameHandler = ^(CGRect frame) {
            if (weakSelf.ue_viewWillDisappearFinished) { return; }
            
            CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height + frame.origin.y);
            weakSelf.ue_navigationBar.frame = newFrame;
        };
        
        [self updateNavigationBarHierarchy];
        [self changeNavigationBarUserInteractionState];
    }
    
    self.ue_viewWillDisappearFinished = NO;
    [self ue_viewWillAppear:animated];
}

- (void)ue_viewDidAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        BOOL interactivePopGestureRecognizerEnabled = self.navigationController.viewControllers.count > 1;
        self.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
        [self changeNavigationBarUserInteractionState];
    }
    
    [self ue_viewDidAppear:animated];
}

- (void)ue_viewWillDisappear:(BOOL)animated {
    self.ue_viewWillDisappearFinished = YES;
    [self ue_viewWillDisappear:animated];
}

- (void)ue_viewWillLayoutSubviews {    
    [self updateNavigationBarHierarchy];
    [self ue_viewWillLayoutSubviews];
}

#pragma mark - Private
- (void)updateNavigationBarAppearance {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        [self.navigationController ue_configureNavigationBar];
        
        self.ue_navigationBar.backgroundColor = self.ue_navigationBarBackgroundColor;
        self.ue_navigationBar.shadowImageView.image = self.ue_shadowImage;
        
        if (self.ue_shadowImageTintColor) {
            self.ue_navigationBar.shadowImageView.image = UINavigationExtensionGetImageFromColor(self.ue_shadowImageTintColor);
        }
        
        self.ue_navigationBar.backgroundImageView.image = self.ue_navigationBarBackgroundImage;
        self.ue_navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, UINavigationExtensionGetNavigationBarHeight());
        [self.ue_navigationBar enableBlurEffect:self.ue_useSystemBlurNavigationBar];
        
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            [self.navigationController.view insertSubview:self.ue_navigationBar atIndex:1];
        } else {
            [self.view addSubview:self.ue_navigationBar];
        }
        
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]] && self.ue_automaticallyHideNavigationBarInChildViewController) {
            self.ue_navigationBar.hidden = YES;
        }
    }
}

- (void)updateNavigationBarHierarchy {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        // FIXED: 修复导航栏 containerView 被遮挡问题
        [self.view bringSubviewToFront:self.ue_navigationBar];
        [self.view bringSubviewToFront:self.ue_navigationBar.containerView];
    }
}

- (void)changeNavigationBarUserInteractionState {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        BOOL hidesNavigationBar = self.ue_hidesNavigationBar;
        BOOL containerViewUserInteractionEnabled = self.ue_barContainerViewUserInteractionEnabled;
        if ([self isKindOfClass:[UIPageViewController class]] && !hidesNavigationBar) {
            // FIXED: 处理特殊情况，最后显示的为 UIPageViewController
            hidesNavigationBar = self.parentViewController.ue_hidesNavigationBar;
        }
        
        if (hidesNavigationBar) {
            containerViewUserInteractionEnabled = NO;
            self.ue_navigationBar.shadowImageView.image = UINavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.ue_navigationBar.backgroundImageView.image = UINavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.ue_navigationBar.backgroundColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor]; // 返回按钮透明
        }
        
        if (containerViewUserInteractionEnabled) { // 添加试图到 containerView 时可以不随 NavigationBar 的 alpha 变化
            self.ue_navigationBar.userInteractionEnabled = YES;
            self.ue_navigationBar.containerView.userInteractionEnabled = YES;
            self.navigationController.navigationBar.ue_navigationBarUserInteractionDisabled = YES;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        } else {
            self.ue_navigationBar.containerView.hidden = hidesNavigationBar;
            self.ue_navigationBar.userInteractionEnabled = !hidesNavigationBar;
            self.ue_navigationBar.containerView.userInteractionEnabled = containerViewUserInteractionEnabled;
            self.navigationController.navigationBar.ue_navigationBarUserInteractionDisabled = hidesNavigationBar;
            self.navigationController.navigationBar.userInteractionEnabled = !hidesNavigationBar;
        }
    }
}

#pragma mark - Private Getter & Setter
- (BOOL)ue_viewWillDisappearFinished {
    NSNumber *viewWillDisappearFinished = objc_getAssociatedObject(self, _cmd);
    if (viewWillDisappearFinished && [viewWillDisappearFinished isKindOfClass:[NSNumber class]]) {
        return [viewWillDisappearFinished boolValue];
    }
    viewWillDisappearFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, viewWillDisappearFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [viewWillDisappearFinished boolValue];
}

- (void)setUe_viewWillDisappearFinished:(BOOL)ue_viewWillDisappearFinished {
    objc_setAssociatedObject(self, @selector(ue_viewWillDisappearFinished), [NSNumber numberWithBool:ue_viewWillDisappearFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ue_navigationBarInitFinished {
    NSNumber *navigationBarInitFinished = objc_getAssociatedObject(self, _cmd);
    if (navigationBarInitFinished && [navigationBarInitFinished isKindOfClass:[NSNumber class]]) {
        return [navigationBarInitFinished boolValue];
    }
    navigationBarInitFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, navigationBarInitFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [navigationBarInitFinished boolValue];
}

- (void)setUe_navigationBarInitFinished:(BOOL)ue_navigationBarInitFinished {
    objc_setAssociatedObject(self, @selector(ue_navigationBarInitFinished), [NSNumber numberWithBool:ue_navigationBarInitFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter & Setter
- (UENavigationBar *)ue_navigationBar {
    UENavigationBar *bar = objc_getAssociatedObject(self, _cmd);
    if (bar && [bar isKindOfClass:[UENavigationBar class]]) {
        return bar;
    }
    bar = [[UENavigationBar alloc] initWithFrame:CGRectZero];
    objc_setAssociatedObject(self, _cmd, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bar;
}

- (UIColor *)ue_navigationBarBackgroundColor {
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color && [color isKindOfClass:[UIColor class]]) {
        return color;
    }
    color = self.navigationController.ue_appearance.backgorundColor;
    objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (UIImage *)ue_navigationBarBackgroundImage {
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    image = self.navigationController.ue_appearance.backgorundImage;
    objc_setAssociatedObject(self, _cmd, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return image;
}

- (UIColor *)ue_barBarTintColor {
    UIColor *barBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (barBarTintColor && [barBarTintColor isKindOfClass:[UIColor class]]) {
        return barBarTintColor;
    }
    barBarTintColor = nil;
    objc_setAssociatedObject(self, _cmd, barBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barBarTintColor;
}

- (UIColor *)ue_barTintColor {
    UIColor *barTintColor = objc_getAssociatedObject(self, _cmd);
    if (barTintColor && [barTintColor isKindOfClass:[UIColor class]]) {
        return barTintColor;
    }
    barTintColor = self.navigationController.ue_appearance.tintColor;
    objc_setAssociatedObject(self, _cmd, barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barTintColor;
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    NSDictionary *titleTextAttributes = objc_getAssociatedObject(self, _cmd);
    if (titleTextAttributes && [titleTextAttributes isKindOfClass:[NSDictionary class]]) {
        return titleTextAttributes;
    }
    titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    objc_setAssociatedObject(self, _cmd, titleTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return titleTextAttributes;
}

- (UIImage *)ue_shadowImage {
    UIImage *shadowImage = objc_getAssociatedObject(self, _cmd);
    if (shadowImage && [shadowImage isKindOfClass:[UIImage class]]) {
        return shadowImage;
    }
    shadowImage = self.navigationController.ue_appearance.shadowImage;
    objc_setAssociatedObject(self, _cmd, shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImage;
}

- (UIColor *)ue_shadowImageTintColor {
    UIColor *shadowImageTintColor = objc_getAssociatedObject(self, _cmd);
    if (shadowImageTintColor && [shadowImageTintColor isKindOfClass:[UIColor class]]) {
        return shadowImageTintColor;
    }
    shadowImageTintColor = nil;
    objc_setAssociatedObject(self, _cmd, shadowImageTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImageTintColor;
}

- (UIImage *)ue_backImage {
    UIImage *backImage = objc_getAssociatedObject(self, _cmd);
    if (backImage && [backImage isKindOfClass:[UIImage class]]) {
        return backImage;
    }
    backImage = self.navigationController.ue_appearance.backImage;
    objc_setAssociatedObject(self, _cmd, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backImage;
}

- (UIView *)ue_backButtonCustomView {
    UIView *backButtonCustomView = objc_getAssociatedObject(self, _cmd);
    if (backButtonCustomView && [backButtonCustomView isKindOfClass:[UIView class]]) {
        return backButtonCustomView;
    }
    backButtonCustomView = self.navigationController.ue_appearance.backButtonCustomView;
    objc_setAssociatedObject(self, _cmd, backButtonCustomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backButtonCustomView;
}

- (BOOL)ue_useSystemBlurNavigationBar {
    NSNumber *useSystemBlurNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (useSystemBlurNavigationBar && [useSystemBlurNavigationBar isKindOfClass:[NSNumber class]]) {
        return [useSystemBlurNavigationBar boolValue];
    }
    useSystemBlurNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, useSystemBlurNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [useSystemBlurNavigationBar boolValue];
}

- (BOOL)ue_interactivePopGestureDisable {
    NSNumber *interactivePopGestureDisable = objc_getAssociatedObject(self, _cmd);
    if (interactivePopGestureDisable && [interactivePopGestureDisable isKindOfClass:[NSNumber class]]) {
        return [interactivePopGestureDisable boolValue];
    }
    interactivePopGestureDisable = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, interactivePopGestureDisable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [interactivePopGestureDisable boolValue];
}

- (BOOL)ue_enableFullScreenInteractivePopGesture {
    NSNumber *enableFullScreenInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (enableFullScreenInteractivePopGesture && [enableFullScreenInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [enableFullScreenInteractivePopGesture boolValue];
    }
    enableFullScreenInteractivePopGesture = [NSNumber numberWithBool:UINavigationExtensionFullscreenPopGestureEnable];
    objc_setAssociatedObject(self, _cmd, enableFullScreenInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [enableFullScreenInteractivePopGesture boolValue];
}

- (BOOL)ue_automaticallyHideNavigationBarInChildViewController {
    NSNumber *automaticallyHideNavigationBarInChildViewController = objc_getAssociatedObject(self, _cmd);
    if (automaticallyHideNavigationBarInChildViewController && [automaticallyHideNavigationBarInChildViewController isKindOfClass:[NSNumber class]]) {
        return [automaticallyHideNavigationBarInChildViewController boolValue];
    }
    automaticallyHideNavigationBarInChildViewController = [NSNumber numberWithBool:YES];
    objc_setAssociatedObject(self, _cmd, automaticallyHideNavigationBarInChildViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [automaticallyHideNavigationBarInChildViewController boolValue];
}

- (BOOL)ue_hidesNavigationBar {
    NSNumber *hidesNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (hidesNavigationBar && [hidesNavigationBar isKindOfClass:[NSNumber class]]) {
        return [hidesNavigationBar boolValue];
    }
    hidesNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, hidesNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [hidesNavigationBar boolValue];
}

- (BOOL)ue_barContainerViewUserInteractionEnabled {
    NSNumber *barContainerViewUserInteractionEnabled = objc_getAssociatedObject(self, _cmd);
    if (barContainerViewUserInteractionEnabled && [barContainerViewUserInteractionEnabled isKindOfClass:[NSNumber class]]) {
        return [barContainerViewUserInteractionEnabled boolValue];
    }
    barContainerViewUserInteractionEnabled = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, barContainerViewUserInteractionEnabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [barContainerViewUserInteractionEnabled boolValue];
}

- (CGFloat)ue_interactivePopMaxAllowedDistanceToLeftEdge {
    NSNumber *interactivePopMaxAllowedDistanceToLeftEdge = objc_getAssociatedObject(self, _cmd);
    if (interactivePopMaxAllowedDistanceToLeftEdge && [interactivePopMaxAllowedDistanceToLeftEdge isKindOfClass:[NSNumber class]]) {
#if CGFLOAT_IS_DOUBLE
        return [interactivePopMaxAllowedDistanceToLeftEdge doubleValue];
#else
        return [interactivePopMaxAllowedDistanceToLeftEdge floatValue];
#endif
    }
    return 0.0;
}

- (void)setUe_interactivePopMaxAllowedDistanceToLeftEdge:(CGFloat)ue_interactivePopMaxAllowedDistanceToLeftEdge {
    NSNumber *interactivePopMaxAllowedDistanceToLeftEdge;
#if CGFLOAT_IS_DOUBLE
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithDouble:MAX(0, ue_interactivePopMaxAllowedDistanceToLeftEdge)];
#else
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithFloat:MAX(0, ue_interactivePopMaxAllowedDistanceToLeftEdge)];
#endif
    objc_setAssociatedObject(self, @selector(ue_interactivePopMaxAllowedDistanceToLeftEdge), interactivePopMaxAllowedDistanceToLeftEdge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ue_triggerSystemBackButtonHandle {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
