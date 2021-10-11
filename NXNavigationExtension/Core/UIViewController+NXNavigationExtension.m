//
// UIViewController+NXNavigationExtension.m
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

#import "NXNavigationConfiguration.h"
#import "NXNavigationExtensionPrivate.h"
#import "NXNavigationExtensionRuntime.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"

CG_INLINE BOOL
NXNavigationExtensionEdgesForExtendedLayoutEnabled(UIRectEdge edge) {
    return edge == UIRectEdgeNone;
}

@interface UIViewController (NXNavigationExtension)

@property (nonatomic, assign) BOOL nx_navigationBarInitialize;
@property (nonatomic, assign) BOOL nx_viewWillDisappearFinished;

@end


@implementation UIViewController (NXNavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIViewController class], @selector(viewDidLoad), ^(__kindof UIViewController * _Nonnull selfObject) {
            [selfObject nx_configureNXNavigationBar];
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIViewController class], @selector(viewWillLayoutSubviews), ^(__kindof UIViewController * _Nonnull selfObject) {
            [selfObject nx_configureNXNavigationBar];
            [selfObject nx_updateNavigationBarHierarchy];
        });
        
        NXNavigationExtensionOverrideImplementation([UIViewController class], @selector(extendedLayoutIncludesOpaqueBars), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^BOOL (__unsafe_unretained __kindof UIViewController *selfObject) {
                BOOL (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (BOOL (*)(id, SEL))originalIMPProvider();
                BOOL result = originSelectorIMP(selfObject, originCMD);

                // fix: edgesForExtendedLayoutEnabled instance dynamic changed.
                if (selfObject.navigationController && selfObject.navigationController.nx_useNavigationBar) {
                    selfObject.nx_navigationBar.edgesForExtendedLayoutEnabled = NXNavigationExtensionEdgesForExtendedLayoutEnabled(selfObject.edgesForExtendedLayout);
                    selfObject.nx_navigationBar.frame = selfObject.navigationController.navigationBar.frame;
                }
                return result;
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UIViewController class], @selector(edgesForExtendedLayout), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^UIRectEdge (__unsafe_unretained __kindof UIViewController *selfObject) {
                UIRectEdge (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (UIRectEdge (*)(id, SEL))originalIMPProvider();
                UIRectEdge result = originSelectorIMP(selfObject, originCMD);

                // fix: edgesForExtendedLayoutEnabled instance dynamic changed.
                if (selfObject.navigationController && selfObject.navigationController.nx_useNavigationBar) {
                    selfObject.nx_navigationBar.edgesForExtendedLayoutEnabled = NXNavigationExtensionEdgesForExtendedLayoutEnabled(result);
                    selfObject.nx_navigationBar.frame = selfObject.navigationController.navigationBar.frame;
                }
                return result;
            };
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class], @selector(viewWillAppear:), BOOL, ^(__kindof UIViewController * _Nonnull selfObject, BOOL animated) {
            selfObject.nx_viewWillDisappearFinished = NO;
            if (selfObject.navigationController && selfObject.navigationController.nx_useNavigationBar) {
                // fix: 修复 viewDidLoad 调用时，界面还没有显示无法获取到 navigationController 对象问题
                [selfObject nx_configureNXNavigationBar];
                // 还原上一个视图控制器对导航栏的修改
                [selfObject nx_updateNavigationBarAppearance];
                [selfObject nx_updateNavigationBarHierarchy];
                [selfObject nx_updateNavigationBarSubviewState];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class], @selector(viewDidAppear:), BOOL, ^(__kindof UIViewController * _Nonnull selfObject, BOOL animated) {
            if (selfObject.navigationController && selfObject.navigationController.nx_useNavigationBar) {
                BOOL interactivePopGestureRecognizerEnabled = selfObject.navigationController.viewControllers.count > 1;
                selfObject.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
                [selfObject nx_updateNavigationBarSubviewState];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class], @selector(viewWillDisappear:), BOOL, ^(__kindof UIViewController * _Nonnull selfObject, BOOL animated) {
            selfObject.nx_viewWillDisappearFinished = YES;
        });
    });
}

#pragma mark - Private

- (void)nx_configureNXNavigationBar {
    if (self.navigationController && self.navigationController.nx_useNavigationBar && !self.nx_navigationBarInitialize) {
        self.nx_navigationBarInitialize = YES;
        // 首次加载时调用一次外部修改
        NXNavigationPrepareConfigurationCallback callback = self.nx_prepareConfigureViewControllerCallback;
        if (callback) {
            self.nx_configuration = callback(self, [self.nx_configuration copy]);
        }
        
        [self.navigationController nx_configureNavigationBar];
        [self nx_setupNavigationBar];
        [self nx_updateNavigationBarAppearance];
    }
}

- (void)nx_setupNavigationBar {
    if (!self.nx_navigationBar) return;
    
    self.nx_navigationBar.frame = self.navigationController.navigationBar.frame;
    if (![self.view isKindOfClass:[UIScrollView class]]) {
        [self.view addSubview:self.nx_navigationBar];
    }
    
    __weak typeof(self) weakSelf = self; // CurrentViewController handle nx_didUpdatePropertiesHandler callback
    self.navigationController.navigationBar.nx_didUpdatePropertiesHandler = ^(UINavigationBar * _Nonnull navigationBar) {
        __kindof UINavigationController *navigationController = (UINavigationController *)navigationBar.delegate;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            for (__kindof UIViewController *viewController in navigationController.viewControllers) {
                [weakSelf nx_adjustNavigationBarAppearanceForUINavigationBar:navigationBar withViewController:viewController];
            }
        } else {
            [weakSelf nx_adjustNavigationBarAppearanceForUINavigationBar:navigationBar withViewController:weakSelf];
        }
    };
}

- (void)nx_adjustNavigationBarAppearanceForUINavigationBar:(UINavigationBar *)navigationBar withViewController:(__kindof UIViewController *)viewController {
    if (viewController.nx_navigationBar) {
        // fix: 视图控制器同时重写 `extendedLayoutIncludesOpaqueBars` 和 `edgesForExtendedLayout` 属性时需要调用这里来修正导航栏。
        viewController.nx_navigationBar.edgesForExtendedLayoutEnabled = NXNavigationExtensionEdgesForExtendedLayoutEnabled(viewController.edgesForExtendedLayout);
    }
    // fix: delay call nx_updateNavigationBarAppearance method.
    if (self == viewController && viewController.nx_viewWillDisappearFinished) { return; }
    viewController.nx_navigationBar.frame = navigationBar.frame;
    viewController.nx_navigationBar.hidden = navigationBar.hidden;
}

- (void)nx_updateNavigationBarAppearance {
    if (self.nx_viewWillDisappearFinished) return; // fix: delay call nx_updateNavigationBarAppearance method.
    
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.nx_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.nx_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.nx_titleTextAttributes;
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.largeTitleTextAttributes = self.nx_largeTitleTextAttributes;
        }
        [self.navigationController nx_configureNavigationBar];
        
        self.nx_navigationBar.backgroundColor = self.nx_navigationBarBackgroundColor;
        self.nx_navigationBar.shadowImageView.image = self.nx_shadowImage;
        
        if (self.nx_shadowImageTintColor) {
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor(self.nx_shadowImageTintColor);
        }
        
        self.nx_navigationBar.backgroundImageView.image = self.nx_navigationBarBackgroundImage;
        self.nx_navigationBar.blurEffectEnabled = self.nx_useBlurNavigationBar;
        
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]] && self.nx_automaticallyHideNavigationBarInChildViewController) {
            self.nx_navigationBar.hidden = YES;
        }
    }
}

- (void)nx_updateNavigationBarHierarchy {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        // fix: 修复导航栏 contentView 被遮挡问题
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *view = (UIScrollView *)self.view;
            [view.nx_navigationBar removeFromSuperview];
            [self.nx_navigationBar removeFromSuperview];
            
            view.nx_navigationBar = self.nx_navigationBar;
            [self.view.superview addSubview:self.nx_navigationBar];
        } else {
            [self.view bringSubviewToFront:self.nx_navigationBar];
            [self.view bringSubviewToFront:self.nx_navigationBar.contentView];
        }
    }
}

- (void)nx_updateNavigationBarSubviewState {
    if (self.navigationController && self.navigationController.nx_useNavigationBar) {
        BOOL translucentNavigationBar = self.nx_translucentNavigationBar;
        BOOL contentViewWithoutNavigtionBar = self.nx_contentViewWithoutNavigtionBar;
        if ([self isKindOfClass:[UIPageViewController class]] && !translucentNavigationBar) {
            // fix: 处理特殊情况，最后显示的为 UIPageViewController
            translucentNavigationBar = self.parentViewController.nx_translucentNavigationBar;
        }
        
        if (translucentNavigationBar) {
            contentViewWithoutNavigtionBar = NO;
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundColor = [UIColor clearColor];
            self.navigationItem.titleView.hidden = YES;
            self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor];
            
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor clearColor]};
            self.navigationController.navigationBar.titleTextAttributes = textAttributes;
            if (@available(iOS 11.0, *)) {
                self.navigationController.navigationBar.largeTitleTextAttributes = textAttributes;
            }
        }
        
        if (contentViewWithoutNavigtionBar) { // 添加 subView 到 contentView 时可以不随 NavigationBar 的 alpha 变化
            self.nx_navigationBar.contentView.userInteractionEnabled = YES;
            self.nx_navigationBar.userInteractionEnabled = YES;
            self.navigationController.navigationBar.nx_userInteractionEnabled = NO;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        } else {
            self.nx_navigationBar.contentView.hidden = translucentNavigationBar;
            self.nx_navigationBar.contentView.userInteractionEnabled = contentViewWithoutNavigtionBar;
            self.nx_navigationBar.userInteractionEnabled = !translucentNavigationBar;
            self.navigationController.navigationBar.nx_userInteractionEnabled = !translucentNavigationBar;
            self.navigationController.navigationBar.userInteractionEnabled = !translucentNavigationBar;
        }
    }
}

#pragma mark - Private Getter & Setter

- (BOOL)nx_navigationBarInitialize {
    NSNumber *navigationBarInitialize = objc_getAssociatedObject(self, _cmd);
    if (navigationBarInitialize && [navigationBarInitialize isKindOfClass:[NSNumber class]]) {
        return [navigationBarInitialize boolValue];
    }
    navigationBarInitialize = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, navigationBarInitialize, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [navigationBarInitialize boolValue];
}

- (void)setNx_navigationBarInitialize:(BOOL)nx_navigationBarInitialize {
    objc_setAssociatedObject(self, @selector(nx_navigationBarInitialize), [NSNumber numberWithBool:nx_navigationBarInitialize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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

#pragma mark - Getter & Setter

- (NXNavigationBar *)nx_navigationBar {
    // 如果之前已经创建过 NXNavigationBar 实例，则直接返回原来已经创建好的实例对象。
    NXNavigationBar *bar = objc_getAssociatedObject(self, _cmd);
    if (bar && [bar isKindOfClass:[NXNavigationBar class]]) {
        return bar;
    }
    
    if (!self.navigationController || !self.nx_configuration) {
        return bar;
    }
    
    bar = [[NXNavigationBar alloc] initWithFrame:CGRectZero];
    objc_setAssociatedObject(self, _cmd, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return bar;
}

- (UIColor *)nx_navigationBarBackgroundColor {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (color && [color isKindOfClass:[UIColor class]]) {
        return color;
    }
    color = configuration.navigationBarAppearance.backgroundColor;
    objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return color;
}

- (UIImage *)nx_navigationBarBackgroundImage {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIImage *image = objc_getAssociatedObject(self, _cmd);
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    image = configuration.navigationBarAppearance.backgroundImage;
    objc_setAssociatedObject(self, _cmd, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return image;
}

- (UIColor *)nx_barBarTintColor {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIColor *barBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (barBarTintColor && [barBarTintColor isKindOfClass:[UIColor class]]) {
        return barBarTintColor;
    }
    barBarTintColor = configuration.navigationBarAppearance.barTintColor;
    objc_setAssociatedObject(self, _cmd, barBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barBarTintColor;
}

- (UIColor *)nx_barTintColor {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIColor *barTintColor = objc_getAssociatedObject(self, _cmd);
    if (barTintColor && [barTintColor isKindOfClass:[UIColor class]]) {
        return barTintColor;
    }
    barTintColor = configuration.navigationBarAppearance.tintColor;
    objc_setAssociatedObject(self, _cmd, barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barTintColor;
}

- (NSDictionary<NSAttributedStringKey, id> *)nx_titleTextAttributes {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSDictionary<NSAttributedStringKey, id> *titleTextAttributes = configuration.navigationBarAppearance.titleTextAttributes;
    if (titleTextAttributes) {
        return titleTextAttributes;
    }
    
    UIColor *color = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor whiteColor];
            }
            return [UIColor blackColor];
        }];
    }
    
    titleTextAttributes = @{NSForegroundColorAttributeName: color};
    if (@available(iOS 13.0, *)) {
        titleTextAttributes = @{NSForegroundColorAttributeName: [color resolvedColorWithTraitCollection:self.view.traitCollection]};
    }
    return titleTextAttributes;
}

- (NSDictionary<NSAttributedStringKey, id> *)nx_largeTitleTextAttributes {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSDictionary<NSAttributedStringKey, id> *largeTitleTextAttributes = configuration.navigationBarAppearance.largeTitleTextAttributes;
    if (largeTitleTextAttributes) {
        return largeTitleTextAttributes;
    }
    
    return [self nx_titleTextAttributes];
}

- (UIImage *)nx_shadowImage {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIImage *shadowImage = objc_getAssociatedObject(self, _cmd);
    if (shadowImage && [shadowImage isKindOfClass:[UIImage class]]) {
        return shadowImage;
    }
    shadowImage = configuration.navigationBarAppearance.shadowImage;
    objc_setAssociatedObject(self, _cmd, shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImage;
}

- (UIColor *)nx_shadowImageTintColor {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIColor *shadowImageTintColor = objc_getAssociatedObject(self, _cmd);
    if (shadowImageTintColor && [shadowImageTintColor isKindOfClass:[UIColor class]]) {
        return shadowImageTintColor;
    }
    shadowImageTintColor = configuration.navigationBarAppearance.shadowColor;
    objc_setAssociatedObject(self, _cmd, shadowImageTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return shadowImageTintColor;
}

- (UIImage *)nx_backImage {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIImage *backImage = objc_getAssociatedObject(self, _cmd);
    if (backImage && [backImage isKindOfClass:[UIImage class]]) {
        return backImage;
    }
    backImage = configuration.navigationBarAppearance.backImage;
    objc_setAssociatedObject(self, _cmd, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backImage;
}

- (UIImage *)nx_landscapeBackImage {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIImage *landscapeBackImage = objc_getAssociatedObject(self, _cmd);
    if (landscapeBackImage && [landscapeBackImage isKindOfClass:[UIImage class]]) {
        return landscapeBackImage;
    }
    landscapeBackImage = configuration.navigationBarAppearance.landscapeBackImage;
    objc_setAssociatedObject(self, _cmd, landscapeBackImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return landscapeBackImage;
}

- (UIView *)nx_backButtonCustomView {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    UIView *backButtonCustomView = objc_getAssociatedObject(self, _cmd);
    if (backButtonCustomView && [backButtonCustomView isKindOfClass:[UIView class]]) {
        return backButtonCustomView;
    }
    backButtonCustomView = configuration.navigationBarAppearance.backButtonCustomView;
    objc_setAssociatedObject(self, _cmd, backButtonCustomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return backButtonCustomView;
}

- (NSString *)nx_systemBackButtonTitle {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSString *systemBackButtonTitle = objc_getAssociatedObject(self, _cmd);
    if (systemBackButtonTitle && [systemBackButtonTitle isKindOfClass:[NSString class]]) {
        return systemBackButtonTitle;
    }
    systemBackButtonTitle = configuration.navigationBarAppearance.systemBackButtonTitle;
    objc_setAssociatedObject(self, _cmd, systemBackButtonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return systemBackButtonTitle;
}

- (UIEdgeInsets)nx_backImageInsets {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSString *insetsValue = objc_getAssociatedObject(self, _cmd);
    if (insetsValue && [insetsValue isKindOfClass:[NSString class]]) {
        return UIEdgeInsetsFromString(insetsValue);
    }
    UIEdgeInsets insets = configuration.navigationBarAppearance.backImageInsets;
    
    objc_setAssociatedObject(self, _cmd, NSStringFromUIEdgeInsets(insets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return insets;
}

- (UIEdgeInsets)nx_landscapeBackImageInsets {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSString *insetsValue = objc_getAssociatedObject(self, _cmd);
    if (insetsValue && [insetsValue isKindOfClass:[NSString class]]) {
        return UIEdgeInsetsFromString(insetsValue);
    }
    UIEdgeInsets insets = configuration.navigationBarAppearance.landscapeBackImageInsets;
    objc_setAssociatedObject(self, _cmd, NSStringFromUIEdgeInsets(insets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return insets;
}

- (BOOL)nx_useSystemBackButton {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *useSystemBackButton = objc_getAssociatedObject(self, _cmd);
    if (useSystemBackButton && [useSystemBackButton isKindOfClass:[NSNumber class]]) {
        return [useSystemBackButton boolValue];
    }
    useSystemBackButton = [NSNumber numberWithBool:configuration.navigationBarAppearance.useSystemBackButton];
    objc_setAssociatedObject(self, _cmd, useSystemBackButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [useSystemBackButton boolValue];
}

- (BOOL)nx_useBlurNavigationBar {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *useBlurNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (useBlurNavigationBar && [useBlurNavigationBar isKindOfClass:[NSNumber class]]) {
        return [useBlurNavigationBar boolValue];
    }
    useBlurNavigationBar = [NSNumber numberWithBool:configuration.viewControllerPreferences.useBlurNavigationBar];
    objc_setAssociatedObject(self, _cmd, useBlurNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [useBlurNavigationBar boolValue];
}

- (BOOL)nx_disableInteractivePopGesture {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *disableInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (disableInteractivePopGesture && [disableInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [disableInteractivePopGesture boolValue];
    }
    disableInteractivePopGesture = [NSNumber numberWithBool:configuration.viewControllerPreferences.disableInteractivePopGesture];
    objc_setAssociatedObject(self, _cmd, disableInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [disableInteractivePopGesture boolValue];
}

- (BOOL)nx_enableFullscreenInteractivePopGesture {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *enableFullscreenInteractivePopGesture = objc_getAssociatedObject(self, _cmd);
    if (enableFullscreenInteractivePopGesture && [enableFullscreenInteractivePopGesture isKindOfClass:[NSNumber class]]) {
        return [enableFullscreenInteractivePopGesture boolValue];
    }
    enableFullscreenInteractivePopGesture = [NSNumber numberWithBool:configuration.viewControllerPreferences.enableFullscreenInteractivePopGesture];
    objc_setAssociatedObject(self, _cmd, enableFullscreenInteractivePopGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [enableFullscreenInteractivePopGesture boolValue];
}

- (BOOL)nx_automaticallyHideNavigationBarInChildViewController {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *automaticallyHideNavigationBarInChildViewController = objc_getAssociatedObject(self, _cmd);
    if (automaticallyHideNavigationBarInChildViewController && [automaticallyHideNavigationBarInChildViewController isKindOfClass:[NSNumber class]]) {
        return [automaticallyHideNavigationBarInChildViewController boolValue];
    }
    automaticallyHideNavigationBarInChildViewController = [NSNumber numberWithBool:configuration.viewControllerPreferences.automaticallyHideNavigationBarInChildViewController];
    objc_setAssociatedObject(self, _cmd, automaticallyHideNavigationBarInChildViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [automaticallyHideNavigationBarInChildViewController boolValue];
}

- (BOOL)nx_translucentNavigationBar {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *translucentNavigationBar = objc_getAssociatedObject(self, _cmd);
    if (translucentNavigationBar && [translucentNavigationBar isKindOfClass:[NSNumber class]]) {
        return [translucentNavigationBar boolValue];
    }
    translucentNavigationBar = [NSNumber numberWithBool:configuration.viewControllerPreferences.translucentNavigationBar];
    objc_setAssociatedObject(self, _cmd, translucentNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [translucentNavigationBar boolValue];
}

- (BOOL)nx_contentViewWithoutNavigtionBar {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *contentViewWithoutNavigtionBar = objc_getAssociatedObject(self, _cmd);
    if (contentViewWithoutNavigtionBar && [contentViewWithoutNavigtionBar isKindOfClass:[NSNumber class]]) {
        return [contentViewWithoutNavigtionBar boolValue];
    }
    contentViewWithoutNavigtionBar = [NSNumber numberWithBool:configuration.viewControllerPreferences.contentViewWithoutNavigtionBar];
    objc_setAssociatedObject(self, _cmd, contentViewWithoutNavigtionBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [contentViewWithoutNavigtionBar boolValue];
}

- (CGFloat)nx_interactivePopMaxAllowedDistanceToLeftEdge {
    NXNavigationConfiguration *configuration = self.nx_configuration;
    NSNumber *interactivePopMaxAllowedDistanceToLeftEdge = objc_getAssociatedObject(self, _cmd);
    if (interactivePopMaxAllowedDistanceToLeftEdge && [interactivePopMaxAllowedDistanceToLeftEdge isKindOfClass:[NSNumber class]]) {
#if CGFLOAT_IS_DOUBLE
        return [interactivePopMaxAllowedDistanceToLeftEdge doubleValue];
#else
        return [interactivePopMaxAllowedDistanceToLeftEdge floatValue];
#endif
    }
    return configuration.viewControllerPreferences.interactivePopMaxAllowedDistanceToLeftEdge;
}

- (void)nx_setNeedsNavigationBarAppearanceUpdate {
    if (self.navigationController && self.navigationController.nx_useNavigationBar && self.navigationController.viewControllers.count > 1) {
        // 手动刷新时调用一次外部修改的配置
        NXNavigationPrepareConfigurationCallback callback = self.nx_prepareConfigureViewControllerCallback;
        if (callback) {
            self.nx_configuration = callback(self, [self.nx_configuration copy]);
        }
        
        NSUInteger length = [self.navigationController.viewControllers indexOfObject:self];
        if (length > 0) {
            // 不包含当前控制器的其他所有控制器
            NSArray<__kindof UIViewController *> *viewControllers = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, length)];
            [self.navigationController nx_configureNavigationBackItemWithViewControllers:viewControllers currentViewController:self];
        }
        
        [self nx_configureNavigationBarWithNavigationController:self.navigationController];
    }
    [self nx_updateNavigationBarAppearance];
    [self nx_updateNavigationBarHierarchy];
    [self nx_updateNavigationBarSubviewState];
}

@end
