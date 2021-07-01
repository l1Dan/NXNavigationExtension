//
// UIViewController+NXNavigationExtension.m
//
// Copyright (c) 2021 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import "NXNavigationBar.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "NXNavigationExtensionMacro.h"
#import "NXNavigationExtensionPrivate.h"

@interface UIViewController (NXNavigationExtension)

@property (nonatomic, assign) BOOL nx_viewWillDisappearFinished;
@property (nonatomic, assign) BOOL nx_navigationBarDidLoadFinished;

@end

@implementation UIViewController (NXNavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionSwizzleMethod([UIViewController class], @selector(viewDidLoad), @selector(nx_viewDidLoad));
        NXNavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillAppear:), @selector(nx_viewWillAppear:));
        NXNavigationExtensionSwizzleMethod([UIViewController class], @selector(viewDidAppear:), @selector(nx_viewDidAppear:));
        NXNavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillDisappear:), @selector(nx_viewWillDisappear:));
        NXNavigationExtensionSwizzleMethod([UIViewController class], @selector(viewWillLayoutSubviews), @selector(nx_viewWillLayoutSubviews));
    });
}

- (void)nx_viewDidLoad {
    self.nx_navigationBarDidLoadFinished = NO;
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        self.nx_navigationBarDidLoadFinished = YES;
        
        [self.navigationController nx_configureNavigationBar];
        [self nx_setupNavigationBar];
        [self nx_updateNavigationBarAppearance];
    }
    
    [self nx_viewDidLoad];
}

- (void)nx_viewWillAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        if (!self.nx_navigationBarDidLoadFinished) {
            // FIXED: 修复 viewDidLoad 调用时，界面还没有显示无法获取到 navigationController 对象问题
            [self.navigationController nx_configureNavigationBar];
            [self nx_setupNavigationBar];
        }
        // 还原上一个视图控制器对导航栏的修改
        [self nx_updateNavigationBarAppearance];
        [self nx_updateNavigationBarHierarchy];
        [self nx_updateNavigationBarSubviewState];
    }
    
    self.nx_viewWillDisappearFinished = NO;
    [self nx_viewWillAppear:animated];
}

- (void)nx_viewDidAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        BOOL interactivePopGestureRecognizerEnabled = self.navigationController.viewControllers.count > 1;
        self.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
        [self nx_updateNavigationBarSubviewState];
    }
    
    [self nx_viewDidAppear:animated];
}

- (void)nx_viewWillDisappear:(BOOL)animated {
    self.nx_viewWillDisappearFinished = YES;
    [self nx_viewWillDisappear:animated];
}

- (void)nx_viewWillLayoutSubviews {
    [self nx_updateNavigationBarHierarchy];
    [self nx_viewWillLayoutSubviews];
}

#pragma mark - Private

- (void)nx_setupNavigationBar {
    self.nx_navigationBar.frame = self.navigationController.navigationBar.frame;
    if (![self.view isKindOfClass:[UIScrollView class]]) {
        [self.view addSubview:self.nx_navigationBar];
    }
}

- (void)nx_updateNavigationBarAppearance {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.nx_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.nx_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.nx_titleTextAttributes;
        [self.navigationController nx_configureNavigationBar];
        
        self.nx_navigationBar.backgroundColor = self.nx_navigationBarBackgroundColor;
        self.nx_navigationBar.shadowImageView.image = self.nx_shadowImage;
        
        if (self.nx_shadowImageTintColor) {
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor(self.nx_shadowImageTintColor);
        }
        
        self.nx_navigationBar.backgroundImageView.image = self.nx_navigationBarBackgroundImage;
        [self.nx_navigationBar enableBlurEffect:self.nx_useSystemBlurNavigationBar];
        
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]] && self.nx_automaticallyHideNavigationBarInChildViewController) {
            self.nx_navigationBar.hidden = YES;
        }
        
        __weak typeof(self) weakSelf = self;
        self.navigationController.navigationBar.nx_didUpdateFrameHandler = ^(CGRect frame) {
            if (weakSelf.nx_viewWillDisappearFinished) { return; }
            weakSelf.nx_navigationBar.frame = frame;
        };
    }
}

- (void)nx_updateNavigationBarHierarchy {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        // FIXED: 修复导航栏 containerView 被遮挡问题
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *view = (UIScrollView *)self.view;
            [view.nx_navigationBar removeFromSuperview];
            [self.nx_navigationBar removeFromSuperview];
            
            view.nx_navigationBar = self.nx_navigationBar;
            [self.view.superview addSubview:self.nx_navigationBar];
        } else {
            [self.view bringSubviewToFront:self.nx_navigationBar];
            [self.view bringSubviewToFront:self.nx_navigationBar.containerView];
        }
    }
}

- (void)nx_updateNavigationBarSubviewState {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        BOOL hidesNavigationBar = self.nx_hidesNavigationBar;
        BOOL containerViewWithoutNavigtionBar = self.nx_containerViewWithoutNavigtionBar;
        if ([self isKindOfClass:[UIPageViewController class]] && !hidesNavigationBar) {
            // FIXED: 处理特殊情况，最后显示的为 UIPageViewController
            hidesNavigationBar = self.parentViewController.nx_hidesNavigationBar;
        }
        
        if (hidesNavigationBar) {
            containerViewWithoutNavigtionBar = NO;
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor]; // 返回按钮透明
        }
        
        if (containerViewWithoutNavigtionBar) { // 添加 subView 到 containerView 时可以不随 NavigationBar 的 alpha 变化
            self.nx_navigationBar.userInteractionEnabled = YES;
            self.nx_navigationBar.containerView.userInteractionEnabled = YES;
            self.navigationController.navigationBar.nx_disableUserInteraction = YES;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        } else {
            self.nx_navigationBar.containerView.hidden = hidesNavigationBar;
            self.nx_navigationBar.userInteractionEnabled = !hidesNavigationBar;
            self.nx_navigationBar.containerView.userInteractionEnabled = containerViewWithoutNavigtionBar;
            self.navigationController.navigationBar.nx_disableUserInteraction = hidesNavigationBar;
            self.navigationController.navigationBar.userInteractionEnabled = !hidesNavigationBar;
        }
    }
}

#pragma mark - Private Getter & Setter

- (BOOL)nx_viewWillDisappearFinished {
    NSNumber *viewWillDisappearFinished = objc_getAssociatedObject(self, _cmd);
    if (viewWillDisappearFinished && [viewWillDisappearFinished isKindOfClass:[NSNumber class]]) {
        return [viewWillDisappearFinished boolValue];
    }
    viewWillDisappearFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, viewWillDisappearFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [viewWillDisappearFinished boolValue];
}

- (void)setNx_viewWillDisappearFinished:(BOOL)nx_viewWillDisappearFinished {
    objc_setAssociatedObject(self, @selector(nx_viewWillDisappearFinished), [NSNumber numberWithBool:nx_viewWillDisappearFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nx_navigationBarDidLoadFinished {
    NSNumber *navigationBarDidLoadFinished = objc_getAssociatedObject(self, _cmd);
    if (navigationBarDidLoadFinished && [navigationBarDidLoadFinished isKindOfClass:[NSNumber class]]) {
        return [navigationBarDidLoadFinished boolValue];
    }
    navigationBarDidLoadFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, navigationBarDidLoadFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [navigationBarDidLoadFinished boolValue];
}

- (void)setNx_navigationBarDidLoadFinished:(BOOL)nx_navigationBarDidLoadFinished {
    objc_setAssociatedObject(self, @selector(nx_navigationBarDidLoadFinished), [NSNumber numberWithBool:nx_navigationBarDidLoadFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter & Setter

- (NXNavigationBar *)nx_navigationBar {
    NXNavigationBar *bar = objc_getAssociatedObject(self, _cmd);
    if (bar && [bar isKindOfClass:[NXNavigationBar class]]) {
        return bar;
    }
    bar = [[NXNavigationBar alloc] initWithFrame:CGRectZero];
    objc_setAssociatedObject(self, _cmd, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bar;
}

- (UIColor *)nx_navigationBarBackgroundColor {
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color && [color isKindOfClass:[UIColor class]]) {
        return color;
    }
    color = self.navigationController.nx_appearance.backgorundColor;
    objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (UIImage *)nx_navigationBarBackgroundImage {
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    image = self.navigationController.nx_appearance.backgorundImage;
    objc_setAssociatedObject(self, _cmd, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return image;
}

- (UIColor *)nx_barBarTintColor {
    UIColor *barBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (barBarTintColor && [barBarTintColor isKindOfClass:[UIColor class]]) {
        return barBarTintColor;
    }
    barBarTintColor = nil;
    objc_setAssociatedObject(self, _cmd, barBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barBarTintColor;
}

- (UIColor *)nx_barTintColor {
    UIColor *barTintColor = objc_getAssociatedObject(self, _cmd);
    if (barTintColor && [barTintColor isKindOfClass:[UIColor class]]) {
        return barTintColor;
    }
    barTintColor = self.navigationController.nx_appearance.tintColor;
    objc_setAssociatedObject(self, _cmd, barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barTintColor;
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    UIColor *color = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            }
            return [UIColor blackColor];
        }];
    }

    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName: color};
    if (@available(iOS 13.0, *)) {
        titleTextAttributes = @{NSForegroundColorAttributeName: [color resolvedColorWithTraitCollection:self.view.traitCollection]};
    }
    return titleTextAttributes;
}

- (UIImage *)nx_shadowImage {
    UIImage *shadowImage = objc_getAssociatedObject(self, _cmd);
    if (shadowImage && [shadowImage isKindOfClass:[UIImage class]]) {
        return shadowImage;
    }
    shadowImage = self.navigationController.nx_appearance.shadowImage;
    objc_setAssociatedObject(self, _cmd, shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImage;
}

- (UIColor *)nx_shadowImageTintColor {
    UIColor *shadowImageTintColor = objc_getAssociatedObject(self, _cmd);
    if (shadowImageTintColor && [shadowImageTintColor isKindOfClass:[UIColor class]]) {
        return shadowImageTintColor;
    }
    shadowImageTintColor = nil;
    objc_setAssociatedObject(self, _cmd, shadowImageTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImageTintColor;
}

- (UIImage *)nx_backImage {
    UIImage *backImage = objc_getAssociatedObject(self, _cmd);
    if (backImage && [backImage isKindOfClass:[UIImage class]]) {
        return backImage;
    }
    backImage = self.navigationController.nx_appearance.backImage;
    objc_setAssociatedObject(self, _cmd, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backImage;
}

- (UIView *)nx_backButtonCustomView {
    UIView *backButtonCustomView = objc_getAssociatedObject(self, _cmd);
    if (backButtonCustomView && [backButtonCustomView isKindOfClass:[UIView class]]) {
        return backButtonCustomView;
    }
    backButtonCustomView = self.navigationController.nx_appearance.backButtonCustomView;
    objc_setAssociatedObject(self, _cmd, backButtonCustomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backButtonCustomView;
}

- (BOOL)nx_useSystemBlurNavigationBar {
    NSNumber *useSystemBlurNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (useSystemBlurNavigationBar && [useSystemBlurNavigationBar isKindOfClass:[NSNumber class]]) {
        return [useSystemBlurNavigationBar boolValue];
    }
    useSystemBlurNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, useSystemBlurNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [useSystemBlurNavigationBar boolValue];
}

- (BOOL)nx_disableInteractivePopGesture {
    NSNumber *disableInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (disableInteractivePopGesture && [disableInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [disableInteractivePopGesture boolValue];
    }
    disableInteractivePopGesture = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, disableInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [disableInteractivePopGesture boolValue];
}

- (BOOL)nx_enableFullScreenInteractivePopGesture {
    NSNumber *enableFullScreenInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (enableFullScreenInteractivePopGesture && [enableFullScreenInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [enableFullScreenInteractivePopGesture boolValue];
    }
    enableFullScreenInteractivePopGesture = [NSNumber numberWithBool:UINavigationController.nx_fullscreenPopGestureEnabled];
    objc_setAssociatedObject(self, _cmd, enableFullScreenInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [enableFullScreenInteractivePopGesture boolValue];
}

- (BOOL)nx_automaticallyHideNavigationBarInChildViewController {
    NSNumber *automaticallyHideNavigationBarInChildViewController = objc_getAssociatedObject(self, _cmd);
    if (automaticallyHideNavigationBarInChildViewController && [automaticallyHideNavigationBarInChildViewController isKindOfClass:[NSNumber class]]) {
        return [automaticallyHideNavigationBarInChildViewController boolValue];
    }
    automaticallyHideNavigationBarInChildViewController = [NSNumber numberWithBool:YES];
    objc_setAssociatedObject(self, _cmd, automaticallyHideNavigationBarInChildViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [automaticallyHideNavigationBarInChildViewController boolValue];
}

- (BOOL)nx_hidesNavigationBar {
    NSNumber *hidesNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (hidesNavigationBar && [hidesNavigationBar isKindOfClass:[NSNumber class]]) {
        return [hidesNavigationBar boolValue];
    }
    hidesNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, hidesNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [hidesNavigationBar boolValue];
}

- (BOOL)nx_containerViewWithoutNavigtionBar {
    NSNumber *containerViewWithoutNavigtionBar = objc_getAssociatedObject(self, _cmd);
    if (containerViewWithoutNavigtionBar && [containerViewWithoutNavigtionBar isKindOfClass:[NSNumber class]]) {
        return [containerViewWithoutNavigtionBar boolValue];
    }
    containerViewWithoutNavigtionBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, containerViewWithoutNavigtionBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [containerViewWithoutNavigtionBar boolValue];
}

- (BOOL)nx_backButtonMenuEnabled API_AVAILABLE(ios(14.0)) API_UNAVAILABLE(watchos, tvos) {
    NSNumber *backButtonMenuEnabled = objc_getAssociatedObject(self, _cmd);
    if (backButtonMenuEnabled && [backButtonMenuEnabled isKindOfClass:[NSNumber class]]) {
        return [backButtonMenuEnabled boolValue];
    }
    backButtonMenuEnabled = [NSNumber numberWithBool:UINavigationController.nx_globalBackButtonMenuEnabled];
    objc_setAssociatedObject(self, _cmd, backButtonMenuEnabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [backButtonMenuEnabled boolValue];
}

- (CGFloat)nx_interactivePopMaxAllowedDistanceToLeftEdge {
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

- (void)setNx_interactivePopMaxAllowedDistanceToLeftEdge:(CGFloat)nx_interactivePopMaxAllowedDistanceToLeftEdge {
    NSNumber *interactivePopMaxAllowedDistanceToLeftEdge;
#if CGFLOAT_IS_DOUBLE
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithDouble:MAX(0, nx_interactivePopMaxAllowedDistanceToLeftEdge)];
#else
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithFloat:MAX(0, nx_interactivePopMaxAllowedDistanceToLeftEdge)];
#endif
    objc_setAssociatedObject(self, @selector(nx_interactivePopMaxAllowedDistanceToLeftEdge), interactivePopMaxAllowedDistanceToLeftEdge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nx_setNeedsNavigationBarAppearanceUpdate {
    if (self.navigationController && self.navigationController.nx_useNavigationBar && self.navigationController.viewControllers.count > 1) {
        NSMutableArray< __kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeLastObject];
        [self nx_configureNavigationBarItemWithViewConstrollers:viewControllers];
    }
    [self nx_updateNavigationBarAppearance];
    [self nx_updateNavigationBarHierarchy];
    [self nx_updateNavigationBarSubviewState];
}

@end
