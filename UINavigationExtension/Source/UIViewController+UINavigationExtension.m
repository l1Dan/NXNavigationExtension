//
//  UIViewController+UINavigationExtension.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <objc/runtime.h>

#import "UENavigationBar.h"
#import "UINavigationBar+UINavigationExtension.h"
#import "UINavigationController+UINavigationExtension.h"
#import "UINavigationExtensionMacro.h"
#import "UIViewController+UINavigationExtension.h"

@interface UINavigationBar (UIViewControllerPrivate)

@property (nonatomic, assign) BOOL ue_userInteractionDisabled;

@end

@implementation UINavigationBar (UIViewControllerPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UINavigationBar class], @selector(setUserInteractionEnabled:), @selector(ue_setUserInteractionEnabled:));
    });
}

- (void)ue_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if (self.ue_userInteractionDisabled) {
        [self ue_setUserInteractionEnabled:NO];
        return;
    }
    [self ue_setUserInteractionEnabled:userInteractionEnabled];
}

#pragma mark - Getter & Setter
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

@interface UIViewController (UINavigationExtension)

@property (nonatomic, assign) BOOL ue_viewWillDisappear;
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

    });
}

- (void)ue_viewDidLoad {
    self.ue_navigationBarInitFinished = NO;
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        self.ue_navigationBarInitFinished = YES;
        
        [self.navigationController configureNavigationBar];
        [self updateNavigationBarAppearance];
    }
    
    [self ue_viewDidLoad];
}

- (void)ue_viewWillAppear:(BOOL)animated {
    if (!self.ue_navigationBarInitFinished) {
        [self updateNavigationBarAppearance];
    }
    
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.ue_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.ue_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.ue_titleTextAttributes;
        [self.view bringSubviewToFront:self.ue_navigationBar];
        
        __weak typeof(self) weakSelf = self;
        self.navigationController.navigationBar.ue_didUpdateFrameHandler = ^(CGRect frame) {
            if (weakSelf.ue_viewWillDisappear) { return; }
            
            CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height + frame.origin.y);
            weakSelf.ue_navigationBar.frame = newFrame;
        };
        
        [self changeNavigationBarUserInteractionState];
    }
    
    self.ue_viewWillDisappear = NO;
    [self ue_viewWillAppear: animated];
}

- (void)ue_viewWillDisappear:(BOOL)animated {
    self.ue_viewWillDisappear = YES;
    [self ue_viewWillDisappear: animated];
}

- (void)ue_viewDidAppear:(BOOL)animated {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        BOOL interactivePopGestureRecognizerEnabled = self.navigationController.viewControllers.count > 1;
        self.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
    
        [self changeNavigationBarUserInteractionState];
    }
    
    [self ue_viewDidAppear: animated];
}

#pragma mark - Private
- (void)updateNavigationBarAppearance {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        [self.navigationController configureNavigationBar];
        
        self.ue_navigationBar.backgroundColor = self.ue_navigationBarBackgroundColor;
        self.ue_navigationBar.shadowImageView.image = self.ue_shadowImage;
        
        if (self.ue_shadowImageTintColor) {
            self.ue_navigationBar.shadowImageView.image = UINavigationExtensionImageFromColor(self.ue_shadowImageTintColor);
        }
        
        self.ue_navigationBar.backgroundImageView.image = self.ue_navigationBarBackgroundImage;
        self.ue_navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, UINavigationExtensionNavigationBarHeight());
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

- (void)changeNavigationBarUserInteractionState {
    if (self.navigationController && self.navigationController.ue_useNavigationBar) {
        BOOL hidesNavigationBar = self.ue_hidesNavigationBar;
        BOOL containerViewUserInteractionEnabled = self.ue_barContainerViewUserInteractionEnabled;
        if ([self isKindOfClass:[UIPageViewController class]] && !hidesNavigationBar) {
            // 处理特殊情况，最后显示的为 UIPageViewController
            hidesNavigationBar = self.parentViewController.ue_hidesNavigationBar;
        }
        
        if (hidesNavigationBar) {
            containerViewUserInteractionEnabled = NO;
            self.ue_navigationBar.shadowImageView.image = UINavigationExtensionImageFromColor([UIColor clearColor]);
            self.ue_navigationBar.backgroundImageView.image = UINavigationExtensionImageFromColor([UIColor clearColor]);
            self.ue_navigationBar.backgroundColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor]; // 返回按钮透明
        }
        
        if (containerViewUserInteractionEnabled) {
            self.ue_navigationBar.userInteractionEnabled = YES;
            self.ue_navigationBar.containerView.userInteractionEnabled = YES;
            self.navigationController.navigationBar.ue_userInteractionDisabled = YES;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        } else {
            self.ue_navigationBar.userInteractionEnabled = !hidesNavigationBar;
            self.ue_navigationBar.containerView.userInteractionEnabled = containerViewUserInteractionEnabled;
            self.navigationController.navigationBar.ue_userInteractionDisabled = hidesNavigationBar;
            self.navigationController.navigationBar.userInteractionEnabled = !hidesNavigationBar;
        }
    }
}

#pragma mark - Private Getter & Setter
- (BOOL)ue_viewWillDisappear {
    NSNumber *viewWillDisappear = objc_getAssociatedObject(self, _cmd);
    if (viewWillDisappear && [viewWillDisappear isKindOfClass:[NSNumber class]]) {
        return [viewWillDisappear boolValue];
    }
    viewWillDisappear = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, viewWillDisappear, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [viewWillDisappear boolValue];
}

- (void)setUe_viewWillDisappear:(BOOL)ue_viewWillDisappear {
    objc_setAssociatedObject(self, @selector(ue_viewWillDisappear), [NSNumber numberWithBool:ue_viewWillDisappear], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    color = [UENavigationBar standardAppearance].backgorundColor;
    objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (UIImage *)ue_navigationBarBackgroundImage {
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    image = [UENavigationBar standardAppearance].backgorundImage;
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
    barTintColor = [UENavigationBar standardAppearance].tintColor;
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
    shadowImage = [UENavigationBar standardAppearance].shadowImage;
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
    backImage = [UENavigationBar standardAppearance].backImage;
    objc_setAssociatedObject(self, _cmd, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backImage;
}

- (UIView *)ue_backButtonCustomView {
    UIView *backButtonCustomView = objc_getAssociatedObject(self, _cmd);
    if (backButtonCustomView && [backButtonCustomView isKindOfClass:[UIView class]]) {
        return backButtonCustomView;
    }
    backButtonCustomView = [UENavigationBar standardAppearance].backButtonCustomView;
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
