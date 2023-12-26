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

#import "NXNavigationVirtualWrapperView.h"

#import "NXNavigationExtensionHeaders.h"
#import "NXNavigationExtensionInternal.h"
#import "NXNavigationExtensionRuntime.h"
#import "NXNavigationRouter.h"

#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"

@interface UIViewController (NXNavigationExtensionPrivate)

@property (nonatomic, assign) BOOL nx_navigationBarInitialize;
@property (nonatomic, assign) BOOL nx_navigationVirtualWrapperViewInitialize;
@property (nonatomic, assign) BOOL nx_navigationVirtualWrapperViewNotFound;
@property (nonatomic, assign) BOOL nx_viewWillDisappearFinished;

@property (nonatomic, assign, readonly) BOOL nx_canSetupNavigationBar;
@property (nonatomic, strong, readonly) NXNavigationObservationDelegate *nx_navigationObservationDelegate;

@end

@implementation UIViewController (NXNavigationExtensionPrivate)

- (BOOL)nx_navigationBarInitialize {
    NSNumber *navigationBarInitialize = objc_getAssociatedObject(self, _cmd);
    if (navigationBarInitialize && [navigationBarInitialize isKindOfClass:[NSNumber class]]) {
        return [navigationBarInitialize boolValue];
    }
    return NO;
}

- (void)setNx_navigationBarInitialize:(BOOL)nx_navigationBarInitialize {
    objc_setAssociatedObject(self, @selector(nx_navigationBarInitialize), @(nx_navigationBarInitialize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nx_navigationVirtualWrapperViewInitialize {
    NSNumber *navigationVirtualWrapperViewInitialize = objc_getAssociatedObject(self, _cmd);
    if (navigationVirtualWrapperViewInitialize && [navigationVirtualWrapperViewInitialize isKindOfClass:[NSNumber class]]) {
        return [navigationVirtualWrapperViewInitialize boolValue];
    }
    return NO;
}

- (void)setNx_navigationVirtualWrapperViewInitialize:(BOOL)nx_navigationVirtualWrapperViewInitialize {
    objc_setAssociatedObject(self, @selector(nx_navigationVirtualWrapperViewInitialize), @(nx_navigationVirtualWrapperViewInitialize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nx_navigationVirtualWrapperViewNotFound {
    NSNumber *navigationVirtualWrapperNotFound = objc_getAssociatedObject(self, _cmd);
    if (navigationVirtualWrapperNotFound && [navigationVirtualWrapperNotFound isKindOfClass:[NSNumber class]]) {
        return [navigationVirtualWrapperNotFound boolValue];
    }
    return NO;
}

- (void)setNx_navigationVirtualWrapperViewNotFound:(BOOL)nx_navigationVirtualWrapperViewNotFound {
    objc_setAssociatedObject(self, @selector(nx_navigationVirtualWrapperViewNotFound), @(nx_navigationVirtualWrapperViewNotFound), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nx_viewWillDisappearFinished {
    NSNumber *viewWillDisappearFinished = objc_getAssociatedObject(self, _cmd);
    if (viewWillDisappearFinished && [viewWillDisappearFinished isKindOfClass:[NSNumber class]]) {
        return [viewWillDisappearFinished boolValue];
    }
    return NO;
}

- (void)setNx_viewWillDisappearFinished:(BOOL)nx_viewWillDisappearFinished {
    objc_setAssociatedObject(self, @selector(nx_viewWillDisappearFinished), @(nx_viewWillDisappearFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 检查是否符合导航栏设置的条件
- (BOOL)nx_canSetupNavigationBar {
    return self.navigationController && self.navigationController.nx_useNavigationBar && !self.nx_isChildViewController;
}

- (NXNavigationObservationDelegate *)nx_navigationObservationDelegate {
    NXNavigationObservationDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[NXNavigationObservationDelegate alloc] initWithObserve:self];
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

@end


@implementation UIViewController (NXNavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIViewController class],
                                                                              @selector(viewDidLoad),
                                                                              ^(__kindof UIViewController *_Nonnull selfObject) {
            [selfObject nx_checkChildViewControllers];
            [selfObject nx_configureNXNavigationBar];
            [selfObject nx_configureNavigationVirtualWrapperView];
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIViewController class],
                                                                              @selector(viewWillLayoutSubviews),
                                                                              ^(__kindof UIViewController *_Nonnull selfObject) {
            [selfObject nx_checkChildViewControllers];
            [selfObject nx_configureNXNavigationBar];
            [selfObject nx_configureNavigationVirtualWrapperView];
            [selfObject nx_updateNavigationBarHierarchy];
        });
        
        NXNavigationExtensionOverrideImplementation([UIViewController class],
                                                    @selector(extendedLayoutIncludesOpaqueBars),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^BOOL(__unsafe_unretained __kindof UIViewController *selfObject) {
                BOOL (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (BOOL(*)(id, SEL))originalIMPProvider();
                BOOL result = originSelectorIMP(selfObject, originCMD);
                [selfObject nx_checkChildViewControllers];
                // fix: edgesForExtendedLayoutEnabled instance dynamic changed.
                if (selfObject.nx_canSetupNavigationBar) {
                    [selfObject nx_updateNavigationBarFrame];
                }
                return result;
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UIViewController class],
                                                    @selector(edgesForExtendedLayout),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^UIRectEdge(__unsafe_unretained __kindof UIViewController *selfObject) {
                UIRectEdge (*originSelectorIMP)(id, SEL);
                originSelectorIMP = (UIRectEdge(*)(id, SEL))originalIMPProvider();
                UIRectEdge result = originSelectorIMP(selfObject, originCMD);
                [selfObject nx_checkChildViewControllers];
                // fix: edgesForExtendedLayoutEnabled instance dynamic changed.
                if (selfObject.nx_canSetupNavigationBar) {
                    [selfObject nx_updateNavigationBarFrame];
                }
                return result;
            };
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class],
                                                                                @selector(viewWillAppear:),
                                                                                BOOL,
                                                                                ^(__kindof UIViewController *_Nonnull selfObject, BOOL animated) {
            [selfObject nx_checkChildViewControllers];
            selfObject.nx_viewWillDisappearFinished = NO;
            if (selfObject.nx_canSetupNavigationBar) {
                // fix: 修复 viewDidLoad 调用时，界面还没有显示无法获取到 navigationController 对象问题
                [selfObject nx_configureNXNavigationBar];
                [selfObject nx_configureNavigationVirtualWrapperView];
                // 还原上一个视图控制器对导航栏的修改
                [selfObject nx_updateNavigationBarAppearance];
                [selfObject nx_updateNavigationBarHierarchy];
                [selfObject nx_updateNavigationBarSubviewState];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class],
                                                                                @selector(viewDidAppear:),
                                                                                BOOL,
                                                                                ^(__kindof UIViewController *_Nonnull selfObject, BOOL animated) {
            [selfObject nx_checkChildViewControllers];
            if (selfObject.nx_canSetupNavigationBar) {
                BOOL interactivePopGestureRecognizerEnabled = selfObject.navigationController.viewControllers.count > 1;
                selfObject.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureRecognizerEnabled;
                [selfObject nx_updateNavigationBarSubviewState];
                // perf: 当前 ViewController 以及展示完成，可以检查 NXNavigationVirtualWrapperView 是否存在
                [selfObject nx_checkNavigationVirtualWrapperViewState];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class],
                                                                                @selector(viewWillDisappear:),
                                                                                BOOL,
                                                                                ^(__kindof UIViewController *_Nonnull selfObject, BOOL animated) {
            [selfObject nx_checkChildViewControllers];
            selfObject.nx_viewWillDisappearFinished = YES;
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class],
                                                                                @selector(traitCollectionDidChange:),
                                                                                BOOL,
                                                                                ^(__kindof UIViewController *_Nonnull selfObject, BOOL animated) {
            [selfObject nx_checkChildViewControllers];
            if (selfObject.nx_canSetupNavigationBar) {
                selfObject.nx_configuration.viewControllerPreferences.traitCollection = selfObject.view.traitCollection;
                [selfObject nx_setNeedsNavigationBarAppearanceUpdate];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithSingleArgument([UIViewController class],
                                                                                @selector(addChildViewController:), UIViewController *,
                                                                                ^(__kindof UIViewController *_Nonnull selfObject, __kindof UIViewController *childViewController) {
            if (![selfObject isKindOfClass:[UINavigationController class]]) {
                childViewController.nx_isChildViewController = YES;
                if (childViewController.nx_navigationBar.superview) {
                    [childViewController.nx_navigationBar removeFromSuperview];
                }
            }
        });
    });
}

#pragma mark - Private

- (void)nx_checkChildViewControllers {
    if (self.childViewControllers.count && ![self isKindOfClass:[UINavigationController class]]) {
        for (__kindof UIViewController *childViewController in self.childViewControllers) {
            childViewController.nx_isChildViewController = YES;
            if (childViewController.nx_navigationBar.superview) {
                [childViewController.nx_navigationBar removeFromSuperview];
            }
        }
    }
}

- (void)nx_checkNavigationVirtualWrapperViewState {
    if (@available(iOS 13.0, *)) {
        self.nx_navigationVirtualWrapperViewNotFound = self.nx_navigationVirtualWrapperView ? NO : YES;
    } else {
        self.nx_navigationVirtualWrapperViewNotFound = YES;
    }
}

- (void)nx_configureNXNavigationBar {
    if (self.nx_canSetupNavigationBar && !self.nx_navigationBarInitialize) {
        self.nx_navigationBarInitialize = YES;
        // 调用外部配置信息
        [self nx_executePrepareConfigurationViewControllerCallback];
        [self.navigationController nx_configureNavigationBar];
        [self nx_setupNavigationBar];
        [self nx_updateNavigationBarAppearance];
        // UIViewController self.view.frame 发生改变的情况
        self.nx_navigationObservationDelegate.viewControllerDidUpdateFrameHandler = ^(UIViewController *viewController) {
            [viewController nx_updateNavigationBarFrame];
        };
    }
}

- (void)nx_configureNavigationVirtualWrapperView {
    if (self.nx_navigationVirtualWrapperViewNotFound) return;
    
    if (@available(iOS 13.0, *)) {
        NXNavigationVirtualWrapperViewFilterCallback callback = self.navigationController.nx_filterNavigationVirtualWrapperViewCallback;
        if (callback && self.nx_canSetupNavigationBar && !self.nx_navigationVirtualWrapperViewInitialize) {
            self.nx_navigationVirtualWrapperView = callback(self);
            if (self.nx_navigationVirtualWrapperView) {
                self.nx_navigationVirtualWrapperViewInitialize = YES;
                // 调用外部配置信息
                [self nx_executePrepareConfigurationNavigationVirtualWrapperViewCallback];
                [self nx_setNeedsNavigationBarAppearanceUpdate];
            }
        }
    }
}

- (void)nx_setupNavigationBar {
    if (!self.nx_navigationBar) return;
    
    self.nx_navigationBar.originalNavigationBarFrame = self.navigationController.navigationBar.frame;
    self.nx_navigationBar.frame = self.navigationController.navigationBar.frame;
    if (![self.view isKindOfClass:[UIScrollView class]]) {
        [self.view addSubview:self.nx_navigationBar];
    }
    
    __weak typeof(self) weakSelf = self; // CurrentViewController handle nx_didUpdatePropertiesHandler callback
    self.navigationController.navigationBar.nx_didUpdatePropertiesHandler = ^(UINavigationBar *_Nonnull navigationBar) {
        __kindof UINavigationController *navigationController = (UINavigationController *)navigationBar.delegate;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            for (__kindof UIViewController *viewController in navigationController.viewControllers) {
                [viewController nx_setNavigationBarHidden:navigationBar.hidden];
            }
        } else {
            [weakSelf nx_setNavigationBarHidden:navigationBar.hidden];
        }
    };
}

- (void)nx_setNavigationBarHidden:(BOOL)hidden {
    // fix: delay call nx_updateNavigationBarAppearance method.
    if (self.nx_viewWillDisappearFinished) { return; }
    
    if (self.navigationController.navigationBar.hidden || self.nx_translucentNavigationBar) {
        self.nx_navigationBar.hidden = YES;
        self.nx_navigationBar.userInteractionEnabled = NO;
    } else {
        self.nx_navigationBar.hidden = hidden;
        self.nx_navigationBar.userInteractionEnabled = !hidden;
    }
}

- (void)nx_updateNavigationBarAppearance {
    // fix: delay call nx_updateNavigationBarAppearance method.
    if (self.nx_viewWillDisappearFinished) return;
    
    if (self.nx_canSetupNavigationBar) {
        self.navigationController.navigationBar.barTintColor = self.nx_barBarTintColor;
        self.navigationController.navigationBar.tintColor = self.nx_barTintColor;
        self.navigationController.navigationBar.titleTextAttributes = self.nx_titleTextAttributes;
        self.navigationController.navigationBar.largeTitleTextAttributes = self.nx_largeTitleTextAttributes;
        [self.navigationController nx_configureNavigationBar];
        
        self.nx_navigationBar.backgroundColor = self.nx_navigationBarBackgroundColor;
        self.nx_navigationBar.semanticContentAttribute = self.navigationController.navigationBar.semanticContentAttribute;
        
        if (self.nx_shadowColor) {
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor(self.nx_shadowColor);
        }
        
        if (self.nx_shadowImage) {
            self.nx_navigationBar.shadowImageView.image = self.nx_shadowImage;
        }
        
        self.nx_navigationBar.backgroundImageView.image = self.nx_navigationBarBackgroundImage;
        self.nx_navigationBar.blurEffectEnabled = self.nx_useBlurNavigationBar;
        
        if (self.parentViewController && ![self.parentViewController isKindOfClass:[UINavigationController class]] && self.nx_automaticallyHideNavigationBarInChildViewController) {
            [self nx_setNavigationBarHidden:YES];
        }
    }
}

- (void)nx_updateNavigationBarFrame {
    if (self.nx_canSetupNavigationBar && !self.nx_viewWillDisappearFinished) {
        self.nx_navigationBar.originalNavigationBarFrame = self.navigationController.navigationBar.frame;
        UIView *view = [self.view isKindOfClass:[UIScrollView class]] ? self.view.superview : self.view;
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        self.nx_navigationBar.frame = [navigationBar.superview convertRect:navigationBar.frame toView:view];
    }
}

- (void)nx_updateNavigationBarHierarchy {
    if (self.nx_canSetupNavigationBar) {
        // fix: 修复导航栏 contentView 被遮挡问题
        if ([self.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *view = (UIScrollView *)self.view;
            [view.nx_navigationBar removeFromSuperview];
            [self.nx_navigationBar removeFromSuperview];
            
            view.nx_navigationBar = self.nx_navigationBar;
            [self.view.superview addSubview:self.nx_navigationBar];
        } else {
            [self.view bringSubviewToFront:self.nx_navigationBar];
        }
    }
}

- (void)nx_updateNavigationBarSubviewState {
    if (self.nx_canSetupNavigationBar) {
        BOOL translucentNavigationBar = self.nx_translucentNavigationBar;
        BOOL systemNavigationBarUserInteractionDisabled = self.nx_systemNavigationBarUserInteractionDisabled;
        if ([self isKindOfClass:[UIPageViewController class]] && !translucentNavigationBar) {
            // fix: 处理特殊情况，最后显示的为 UIPageViewController
            translucentNavigationBar = self.parentViewController.nx_translucentNavigationBar;
        }
        
        if (translucentNavigationBar) {
            [self nx_setNavigationBarHidden:YES];
            self.nx_navigationBar.shadowImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundImageView.image = NXNavigationExtensionGetImageFromColor([UIColor clearColor]);
            self.nx_navigationBar.backgroundColor = [UIColor clearColor];
            
            self.navigationItem.titleView.hidden = YES;
            self.navigationController.navigationBar.nx_userInteractionEnabled = NO;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
            self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
            self.navigationController.navigationBar.tintColor = [UIColor clearColor];
            
            NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor clearColor]};
            self.navigationController.navigationBar.titleTextAttributes = textAttributes;
            self.navigationController.navigationBar.largeTitleTextAttributes = textAttributes;
        } else {
            [self nx_setNavigationBarHidden:NO];
            self.nx_navigationBar.userInteractionEnabled = systemNavigationBarUserInteractionDisabled;
            self.navigationController.navigationBar.nx_userInteractionEnabled = !systemNavigationBarUserInteractionDisabled;
            self.navigationController.navigationBar.userInteractionEnabled = !systemNavigationBarUserInteractionDisabled;
        }
    }
}

- (void)nx_executePrepareConfigurationViewControllerCallback {
    if ([self nx_canSetupNavigationBar]) {
        NXViewControllerPrepareConfigurationCallback callback = self.nx_prepareConfigureViewControllerCallback;
        if (callback) {
            callback(self, self.nx_configuration);
        }
    }
}

- (void)nx_executePrepareConfigurationNavigationVirtualWrapperViewCallback {
    if (@available(iOS 13.0, *)) {
        if ([self nx_canSetupNavigationBar] && self.nx_navigationVirtualWrapperViewInitialize) {
            NXViewControllerPrepareConfigurationCallback callback = self.nx_navigationVirtualWrapperView.prepareConfigurationCallback;
            if (callback) {
                callback(self, self.nx_configuration);
            }
        }
    }
}

#pragma mark - Getter & Setter

- (NXNavigationVirtualWrapperView *)nx_navigationVirtualWrapperView API_AVAILABLE(ios(13.0)) {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_navigationVirtualWrapperView:(NXNavigationVirtualWrapperView *)nx_navigationVirtualWrapperView API_AVAILABLE(ios(13.0)) {
    nx_navigationVirtualWrapperView.context.hostingController = self;
    self.nx_navigationTransitionDelegate = (id<NXNavigationTransitionDelegate>)nx_navigationVirtualWrapperView;
    objc_setAssociatedObject(self, @selector(nx_navigationVirtualWrapperView), nx_navigationVirtualWrapperView, OBJC_ASSOCIATION_ASSIGN);
}

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
    return self.nx_configuration.navigationBarAppearance.backgroundColor;
}

- (UIImage *)nx_navigationBarBackgroundImage {
    return self.nx_configuration.navigationBarAppearance.backgroundImage;
}

- (UIColor *)nx_barBarTintColor {
    return self.nx_configuration.navigationBarAppearance.barTintColor;
}

- (UIColor *)nx_barTintColor {
    return self.nx_configuration.navigationBarAppearance.tintColor;
}

- (NSDictionary<NSAttributedStringKey, id> *)nx_titleTextAttributes {
    NSDictionary<NSAttributedStringKey, id> *titleTextAttributes = self.nx_configuration.navigationBarAppearance.titleTextAttributes;
    if (titleTextAttributes) {
        return titleTextAttributes;
    }
    
    UIColor *color = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor *_Nonnull(UITraitCollection *_Nonnull traitCollection) {
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
    NSDictionary<NSAttributedStringKey, id> *largeTitleTextAttributes = self.nx_configuration.navigationBarAppearance.largeTitleTextAttributes;
    if (largeTitleTextAttributes) {
        return largeTitleTextAttributes;
    }
    
    return [self nx_titleTextAttributes];
}

- (UIImage *)nx_shadowImage {
    return self.nx_configuration.navigationBarAppearance.shadowImage;
}

- (UIColor *)nx_shadowColor {
    return self.nx_configuration.navigationBarAppearance.shadowColor;
}

- (UIImage *)nx_backImage {
    return self.nx_configuration.navigationBarAppearance.backImage;
}

- (UIImage *)nx_landscapeBackImage {
    return self.nx_configuration.navigationBarAppearance.landscapeBackImage;
}

- (UIView *)nx_backButtonCustomView {
    return self.nx_configuration.navigationBarAppearance.backButtonCustomView;
}

- (NSString *)nx_systemBackButtonTitle {
    return self.nx_configuration.navigationBarAppearance.systemBackButtonTitle;
}

- (UIEdgeInsets)nx_backImageInsets {
    return self.nx_configuration.navigationBarAppearance.backImageInsets;
}

- (UIEdgeInsets)nx_landscapeBackImageInsets {
    return self.nx_configuration.navigationBarAppearance.landscapeBackImageInsets;
}

- (BOOL)nx_useSystemBackButton {
    return self.nx_configuration.navigationBarAppearance.useSystemBackButton;
}

- (BOOL)nx_useBlurNavigationBar {
    return self.nx_configuration.viewControllerPreferences.useBlurNavigationBar;
}

- (BOOL)nx_disableInteractivePopGesture {
    return self.nx_configuration.viewControllerPreferences.disableInteractivePopGesture;
}

- (BOOL)nx_enableFullScreenInteractivePopGesture {
    return self.nx_configuration.viewControllerPreferences.enableFullScreenInteractivePopGesture;
}

- (BOOL)nx_automaticallyHideNavigationBarInChildViewController {
    return self.nx_configuration.viewControllerPreferences.automaticallyHideNavigationBarInChildViewController;
}

- (BOOL)nx_translucentNavigationBar {
    return self.nx_configuration.viewControllerPreferences.translucentNavigationBar;
}

- (BOOL)nx_systemNavigationBarUserInteractionDisabled {
    return self.nx_configuration.viewControllerPreferences.systemNavigationBarUserInteractionDisabled;
}

- (CGFloat)nx_interactivePopMaxAllowedDistanceToLeftEdge {
    return self.nx_configuration.viewControllerPreferences.interactivePopMaxAllowedDistanceToLeftEdge;
}

- (void)nx_setNeedsNavigationBarAppearanceUpdate {
    NSArray<__kindof UIViewController *> *viewControllers = self.navigationController.viewControllers;
    if (self.nx_canSetupNavigationBar && viewControllers.count > 1) {
        NSUInteger length = [viewControllers indexOfObject:self];
        if (length > 0 && length <= viewControllers.count) {
            // 不包含当前控制器的其他所有控制器
            NSArray<__kindof UIViewController *> *previousViewControllers = [viewControllers subarrayWithRange:NSMakeRange(0, length)];
            [self.navigationController nx_adjustmentSystemBackButtonForViewController:self inViewControllers:previousViewControllers];
        }
        
        [self nx_configureNavigationBarWithNavigationController:self.navigationController];
        
        // 重新检查返回手势是否动态修改
        [self.navigationController nx_configureInteractivePopGestureRecognizerWithViewController:self];
    }
    [self nx_updateNavigationBarAppearance];
    [self nx_updateNavigationBarHierarchy];
    [self nx_updateNavigationBarSubviewState];
}

@end


@implementation UIViewController (NXNavigationExtensionTransition)

- (UIViewController *)nx_popAndPresentViewController:(UIViewController *)viewControllerToPresent
                                            animated:(BOOL)animated
                                          completion:(void (^)(void))completion {
    UINavigationController *navigationController = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)self;
    }
    return [navigationController nx_popViewControllerAnimated:NO completion:^{
        [self presentViewController:viewControllerToPresent animated:animated completion:completion];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                        andPresentViewController:(UIViewController *)viewControllerToPresent
                                                        animated:(BOOL)animated
                                                      completion:(void (^)(void))completion {
    UINavigationController *navigationController = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)self;
    }
    return [navigationController nx_popToViewController:viewController animated:NO completion:^{
        [self presentViewController:viewControllerToPresent animated:animated completion:completion];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootAndPresentViewController:(UIViewController *)viewControllerToPresent
                                                                      animated:(BOOL)animated
                                                                    completion:(void (^)(void))completion {
    UINavigationController *navigationController = self.navigationController;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)self;
    }
    return [navigationController nx_popToRootViewControllerAnimated:NO completion:^{
        [self presentViewController:viewControllerToPresent animated:animated completion:completion];
    }];
}

@end
