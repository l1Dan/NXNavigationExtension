//
// UIViewController+UNXNavigator.m
//
// Copyright (c) 2021 Leo Lee UNXNavigator (https://github.com/l1Dan/UNXNavigator)
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

#import "UNXNavigationBar.h"
#import "UINavigationController+UNXNavigator.h"
#import "UNXNavigatorMacro.h"
#import "UNXNavigatorPrivate.h"

@interface UIViewController (UNXNavigator)

@property (nonatomic, assign) BOOL unx_viewWillDisappearFinished;
@property (nonatomic, assign) BOOL unx_navigationBarDidLoadFinished;

@end

@implementation UIViewController (UNXNavigator)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UNXNavigatorSwizzleMethod([UIViewController class], @selector(viewDidLoad), @selector(unx_viewDidLoad));
        UNXNavigatorSwizzleMethod([UIViewController class], @selector(viewWillAppear:), @selector(unx_viewWillAppear:));
        UNXNavigatorSwizzleMethod([UIViewController class], @selector(viewDidAppear:), @selector(unx_viewDidAppear:));
        UNXNavigatorSwizzleMethod([UIViewController class], @selector(viewWillDisappear:), @selector(unx_viewWillDisappear:));
        UNXNavigatorSwizzleMethod([UIViewController class], @selector(viewWillLayoutSubviews), @selector(unx_viewWillLayoutSubviews));
    });
}

- (void)unx_viewDidLoad {
    self.unx_navigationBarDidLoadFinished = NO;
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        self.unx_navigationBarDidLoadFinished = YES;
        
        [self.navigationController unx_configureNavigationBar];
        [self unx_setupNavigationBar];
        [self unx_updateNavigationBarAppearance];
    }
    
    [self unx_viewDidLoad];
}

- (void)unx_viewWillAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        if (!self.unx_navigationBarDidLoadFinished) {
            // FIXED: 修复 viewDidLoad 调用时，界面还没有显示无法获取到 navigationController 对象问题
            [self.navigationController unx_configureNavigationBar];
            [self unx_setupNavigationBar];
        }
        // 还原上一个视图控制器对导航栏的修改
        [self unx_updateNavigationBarAppearance];
        [self unx_updateNavigationBarHierarchy];
        [self unx_updateNavigationBarSubviewState];
    }
    
    self.unx_viewWillDisappearFinished = NO;
    [self unx_viewWillAppear:animated];
}

- (void)unx_viewDidAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        BOOL interactivePopGestureRecognizerEnabled = self.navigationController.viewControllers.count > 1;
        self.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
        [self unx_updateNavigationBarSubviewState];
    }
    
    [self unx_viewDidAppear:animated];
}

- (void)unx_viewWillDisappear:(BOOL)animated {
    self.unx_viewWillDisappearFinished = YES;
    [self unx_viewWillDisappear:animated];
}

- (void)unx_viewWillLayoutSubviews {
    [self unx_updateNavigationBarHierarchy];
    [self unx_viewWillLayoutSubviews];
}

#pragma mark - Private
- (void)unx_setupNavigationBar {
    self.unx_navigationBar.frame = self.navigationController.navigationBar.frame;
    if (![self.view isKindOfClass:[UIScrollView class]]) {
        [self.view addSubview:self.unx_navigationBar];
    }
}

- (void)unx_updateNavigationBarAppearance {
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.unx_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.unx_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.unx_titleTextAttributes;
        [self.navigationController unx_configureNavigationBar];
        
        self.unx_navigationBar.backgroundColor = self.unx_navigationBarBackgroundColor;
        self.unx_navigationBar.shadowImageView.image = self.unx_shadowImage;
        
        if (self.unx_shadowImageTintColor) {
            self.unx_navigationBar.shadowImageView.image = UNXNavigatorGetImageFromColor(self.unx_shadowImageTintColor);
        }
        
        self.unx_navigationBar.backgroundImageView.image = self.unx_navigationBarBackgroundImage;
        [self.unx_navigationBar enableBlurEffect:self.unx_useSystemBlurNavigationBar];
        
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]] && self.unx_automaticallyHideNavigationBarInChildViewController) {
            self.unx_navigationBar.hidden = YES;
        }
        
        __weak typeof(self) weakSelf = self;
        self.navigationController.navigationBar.unx_didUpdateFrameHandler = ^(CGRect frame) {
            if (weakSelf.unx_viewWillDisappearFinished) { return; }
            weakSelf.unx_navigationBar.frame = frame;
        };
    }
}

- (void)unx_updateNavigationBarHierarchy {
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        // FIXED: 修复导航栏 containerView 被遮挡问题
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *view = (UIScrollView *)self.view;
            [view.unx_navigationBar removeFromSuperview];
            [self.unx_navigationBar removeFromSuperview];
            
            view.unx_navigationBar = self.unx_navigationBar;
            [self.view.superview addSubview:self.unx_navigationBar];
        } else {
            [self.view bringSubviewToFront:self.unx_navigationBar];
            [self.view bringSubviewToFront:self.unx_navigationBar.containerView];
        }
    }
}

- (void)unx_updateNavigationBarSubviewState {
    if (self.navigationController && self.navigationController.unx_useNavigationBar) {
        BOOL hidesNavigationBar = self.unx_hidesNavigationBar;
        BOOL containerViewWithoutNavigtionBar = self.unx_containerViewWithoutNavigtionBar;
        if ([self isKindOfClass:[UIPageViewController class]] && !hidesNavigationBar) {
            // FIXED: 处理特殊情况，最后显示的为 UIPageViewController
            hidesNavigationBar = self.parentViewController.unx_hidesNavigationBar;
        }
        
        if (hidesNavigationBar) {
            containerViewWithoutNavigtionBar = NO;
            self.unx_navigationBar.shadowImageView.image = UNXNavigatorGetImageFromColor([UIColor clearColor]);
            self.unx_navigationBar.backgroundImageView.image = UNXNavigatorGetImageFromColor([UIColor clearColor]);
            self.unx_navigationBar.backgroundColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor]; // 返回按钮透明
        }
        
        if (containerViewWithoutNavigtionBar) { // 添加 subView 到 containerView 时可以不随 NavigationBar 的 alpha 变化
            self.unx_navigationBar.userInteractionEnabled = YES;
            self.unx_navigationBar.containerView.userInteractionEnabled = YES;
            self.navigationController.navigationBar.unx_disableUserInteraction = YES;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        } else {
            self.unx_navigationBar.containerView.hidden = hidesNavigationBar;
            self.unx_navigationBar.userInteractionEnabled = !hidesNavigationBar;
            self.unx_navigationBar.containerView.userInteractionEnabled = containerViewWithoutNavigtionBar;
            self.navigationController.navigationBar.unx_disableUserInteraction = hidesNavigationBar;
            self.navigationController.navigationBar.userInteractionEnabled = !hidesNavigationBar;
        }
    }
}

#pragma mark - Private Getter & Setter
- (BOOL)unx_viewWillDisappearFinished {
    NSNumber *viewWillDisappearFinished = objc_getAssociatedObject(self, _cmd);
    if (viewWillDisappearFinished && [viewWillDisappearFinished isKindOfClass:[NSNumber class]]) {
        return [viewWillDisappearFinished boolValue];
    }
    viewWillDisappearFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, viewWillDisappearFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [viewWillDisappearFinished boolValue];
}

- (void)setUnx_viewWillDisappearFinished:(BOOL)unx_viewWillDisappearFinished {
    objc_setAssociatedObject(self, @selector(unx_viewWillDisappearFinished), [NSNumber numberWithBool:unx_viewWillDisappearFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)unx_navigationBarDidLoadFinished {
    NSNumber *navigationBarDidLoadFinished = objc_getAssociatedObject(self, _cmd);
    if (navigationBarDidLoadFinished && [navigationBarDidLoadFinished isKindOfClass:[NSNumber class]]) {
        return [navigationBarDidLoadFinished boolValue];
    }
    navigationBarDidLoadFinished = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, navigationBarDidLoadFinished, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [navigationBarDidLoadFinished boolValue];
}

- (void)setUnx_navigationBarDidLoadFinished:(BOOL)unx_navigationBarDidLoadFinished {
    objc_setAssociatedObject(self, @selector(unx_navigationBarDidLoadFinished), [NSNumber numberWithBool:unx_navigationBarDidLoadFinished], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter & Setter
- (UNXNavigationBar *)unx_navigationBar {
    UNXNavigationBar *bar = objc_getAssociatedObject(self, _cmd);
    if (bar && [bar isKindOfClass:[UNXNavigationBar class]]) {
        return bar;
    }
    bar = [[UNXNavigationBar alloc] initWithFrame:CGRectZero];
    objc_setAssociatedObject(self, _cmd, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bar;
}

- (UIColor *)unx_navigationBarBackgroundColor {
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color && [color isKindOfClass:[UIColor class]]) {
        return color;
    }
    color = self.navigationController.unx_appearance.backgorundColor;
    objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (UIImage *)unx_navigationBarBackgroundImage {
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    image = self.navigationController.unx_appearance.backgorundImage;
    objc_setAssociatedObject(self, _cmd, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return image;
}

- (UIColor *)unx_barBarTintColor {
    UIColor *barBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (barBarTintColor && [barBarTintColor isKindOfClass:[UIColor class]]) {
        return barBarTintColor;
    }
    barBarTintColor = nil;
    objc_setAssociatedObject(self, _cmd, barBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barBarTintColor;
}

- (UIColor *)unx_barTintColor {
    UIColor *barTintColor = objc_getAssociatedObject(self, _cmd);
    if (barTintColor && [barTintColor isKindOfClass:[UIColor class]]) {
        return barTintColor;
    }
    barTintColor = self.navigationController.unx_appearance.tintColor;
    objc_setAssociatedObject(self, _cmd, barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barTintColor;
}

- (NSDictionary<NSAttributedStringKey,id> *)unx_titleTextAttributes {
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

- (UIImage *)unx_shadowImage {
    UIImage *shadowImage = objc_getAssociatedObject(self, _cmd);
    if (shadowImage && [shadowImage isKindOfClass:[UIImage class]]) {
        return shadowImage;
    }
    shadowImage = self.navigationController.unx_appearance.shadowImage;
    objc_setAssociatedObject(self, _cmd, shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImage;
}

- (UIColor *)unx_shadowImageTintColor {
    UIColor *shadowImageTintColor = objc_getAssociatedObject(self, _cmd);
    if (shadowImageTintColor && [shadowImageTintColor isKindOfClass:[UIColor class]]) {
        return shadowImageTintColor;
    }
    shadowImageTintColor = nil;
    objc_setAssociatedObject(self, _cmd, shadowImageTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImageTintColor;
}

- (UIImage *)unx_backImage {
    UIImage *backImage = objc_getAssociatedObject(self, _cmd);
    if (backImage && [backImage isKindOfClass:[UIImage class]]) {
        return backImage;
    }
    backImage = self.navigationController.unx_appearance.backImage;
    objc_setAssociatedObject(self, _cmd, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backImage;
}

- (UIView *)unx_backButtonCustomView {
    UIView *backButtonCustomView = objc_getAssociatedObject(self, _cmd);
    if (backButtonCustomView && [backButtonCustomView isKindOfClass:[UIView class]]) {
        return backButtonCustomView;
    }
    backButtonCustomView = self.navigationController.unx_appearance.backButtonCustomView;
    objc_setAssociatedObject(self, _cmd, backButtonCustomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backButtonCustomView;
}

- (BOOL)unx_useSystemBlurNavigationBar {
    NSNumber *useSystemBlurNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (useSystemBlurNavigationBar && [useSystemBlurNavigationBar isKindOfClass:[NSNumber class]]) {
        return [useSystemBlurNavigationBar boolValue];
    }
    useSystemBlurNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, useSystemBlurNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [useSystemBlurNavigationBar boolValue];
}

- (BOOL)unx_disableInteractivePopGesture {
    NSNumber *disableInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (disableInteractivePopGesture && [disableInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [disableInteractivePopGesture boolValue];
    }
    disableInteractivePopGesture = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, disableInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [disableInteractivePopGesture boolValue];
}

- (BOOL)unx_enableFullScreenInteractivePopGesture {
    NSNumber *enableFullScreenInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (enableFullScreenInteractivePopGesture && [enableFullScreenInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [enableFullScreenInteractivePopGesture boolValue];
    }
    enableFullScreenInteractivePopGesture = [NSNumber numberWithBool:UINavigationController.unx_fullscreenPopGestureEnabled];
    objc_setAssociatedObject(self, _cmd, enableFullScreenInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [enableFullScreenInteractivePopGesture boolValue];
}

- (BOOL)unx_automaticallyHideNavigationBarInChildViewController {
    NSNumber *automaticallyHideNavigationBarInChildViewController = objc_getAssociatedObject(self, _cmd);
    if (automaticallyHideNavigationBarInChildViewController && [automaticallyHideNavigationBarInChildViewController isKindOfClass:[NSNumber class]]) {
        return [automaticallyHideNavigationBarInChildViewController boolValue];
    }
    automaticallyHideNavigationBarInChildViewController = [NSNumber numberWithBool:YES];
    objc_setAssociatedObject(self, _cmd, automaticallyHideNavigationBarInChildViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [automaticallyHideNavigationBarInChildViewController boolValue];
}

- (BOOL)unx_hidesNavigationBar {
    NSNumber *hidesNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (hidesNavigationBar && [hidesNavigationBar isKindOfClass:[NSNumber class]]) {
        return [hidesNavigationBar boolValue];
    }
    hidesNavigationBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, hidesNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [hidesNavigationBar boolValue];
}

- (BOOL)unx_containerViewWithoutNavigtionBar {
    NSNumber *containerViewWithoutNavigtionBar = objc_getAssociatedObject(self, _cmd);
    if (containerViewWithoutNavigtionBar && [containerViewWithoutNavigtionBar isKindOfClass:[NSNumber class]]) {
        return [containerViewWithoutNavigtionBar boolValue];
    }
    containerViewWithoutNavigtionBar = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, containerViewWithoutNavigtionBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [containerViewWithoutNavigtionBar boolValue];
}

- (CGFloat)unx_interactivePopMaxAllowedDistanceToLeftEdge {
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

- (void)setUnx_interactivePopMaxAllowedDistanceToLeftEdge:(CGFloat)unx_interactivePopMaxAllowedDistanceToLeftEdge {
    NSNumber *interactivePopMaxAllowedDistanceToLeftEdge;
#if CGFLOAT_IS_DOUBLE
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithDouble:MAX(0, unx_interactivePopMaxAllowedDistanceToLeftEdge)];
#else
    interactivePopMaxAllowedDistanceToLeftEdge = [NSNumber numberWithFloat:MAX(0, unx_interactivePopMaxAllowedDistanceToLeftEdge)];
#endif
    objc_setAssociatedObject(self, @selector(unx_interactivePopMaxAllowedDistanceToLeftEdge), interactivePopMaxAllowedDistanceToLeftEdge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)unx_setNeedsNavigationBarAppearanceUpdate {
    if (self.navigationController && self.navigationController.unx_useNavigationBar && self.navigationController.viewControllers.count > 1) {
        [self unx_configureNavigationBarItem];
    }
    [self unx_updateNavigationBarAppearance];
    [self unx_updateNavigationBarHierarchy];
    [self unx_updateNavigationBarSubviewState];
}

@end
