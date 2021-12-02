//
// NXNavigationExtensionInternal.m
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

#import "NXNavigationVirtualWrapperView.h"

#import "NXNavigationExtensionHeaders.h"
#import "NXNavigationExtensionInternal.h"
#import "NXNavigationExtensionRuntime.h"
#import "NXNavigationRouter.h"

#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"


@implementation NXScreenEdgePopGestureRecognizerDelegate

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _navigationController = navigationController;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.navigationController) {
        return YES;
    }
    
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController && topViewController.nx_disableInteractivePopGesture) {
        return NO;
    }
    
    NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
    UIViewController *destinationViewController = (viewControllers && viewControllers.count > 1) ? viewControllers[viewControllers.count - 2] : topViewController;
    if (self.navigationController.nx_useNavigationBar && topViewController) {
        return [self.navigationController nx_viewController:topViewController
                                   preparePopViewController:destinationViewController
                                            interactiveType:NXNavigationInteractiveTypePopGestureRecognizer];
    }
    
    return YES;
}

@end


@implementation NXFullScreenPopGestureRecognizerDelegate

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _navigationController = navigationController;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (![self.navigationController nx_checkFullScreenInteractivePopGestureEnabledWithViewController:topViewController]) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.nx_interactivePopMaxAllowedDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : -1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
    UIViewController *destinationViewController = (viewControllers && viewControllers.count > 1) ? viewControllers[viewControllers.count - 2] : topViewController;
    if (self.navigationController.nx_useNavigationBar && topViewController) {
        return [self.navigationController nx_viewController:topViewController
                                   preparePopViewController:destinationViewController
                                            interactiveType:NXNavigationInteractiveTypePopGestureRecognizer];
    }
    
    return YES;
}

@end


@interface NXNavigationObservationDelegate ()

@property (nonatomic, weak) __kindof UIViewController *observe;

@end


@implementation NXNavigationObservationDelegate

- (instancetype)initWithObserve:(UIViewController *)observe {
    if (self = [super init]) {
        _observe = observe;
        [observe.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self.observe removeObserver:self forKeyPath:@"frame" context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"] && [object isKindOfClass:[UIView class]]) {
        if (self.viewControllerDidUpdateFrameHandler) {
            self.viewControllerDidUpdateFrameHandler(self.observe);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end


@implementation UINavigationItem (NXNavigationExtensionInternal)

- (UIViewController *)nx_viewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_viewController:(UIViewController *)nx_viewController {
    objc_setAssociatedObject(self, @selector(nx_viewController), nx_viewController, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UIScrollView (NXNavigationExtensionInternal)

- (NXNavigationBar *)nx_navigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_navigationBar:(NXNavigationBar *)nx_navigationBar {
    objc_setAssociatedObject(self, @selector(nx_navigationBar), nx_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIScrollView class], @selector(removeFromSuperview), ^(__kindof UIScrollView *_Nonnull selfObject) {
            if (selfObject.nx_navigationBar) {
                [selfObject.nx_navigationBar removeFromSuperview];
            }
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UIScrollView class], @selector(didMoveToSuperview), ^(__kindof UIScrollView *_Nonnull selfObject) {
            if (selfObject.nx_navigationBar && selfObject.superview != selfObject.nx_navigationBar) {
                [selfObject.superview addSubview:selfObject.nx_navigationBar];
                [selfObject.superview bringSubviewToFront:selfObject.nx_navigationBar];
                [selfObject.superview bringSubviewToFront:selfObject.nx_navigationBar.contentView];
            }
        });
    });
}

@end


@implementation UINavigationBar (NXNavigationExtensionInternal)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionOverrideImplementation([UINavigationItem class], @selector(setHidesBackButton:animated:), ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^void(__unsafe_unretained __kindof UINavigationItem *selfObject, BOOL hidden, BOOL animated) {
                void (*originSelectorIMP)(UINavigationItem *, SEL, BOOL, BOOL);
                originSelectorIMP = (void (*)(UINavigationItem *, SEL, BOOL, BOOL))originalIMPProvider();
                
                if (selfObject.nx_viewController.navigationController.nx_useNavigationBar) {
                    BOOL hidesBackButton = !selfObject.nx_viewController.nx_useSystemBackButton;
                    originSelectorIMP(selfObject, originCMD, hidesBackButton, animated);
                } else {
                    originSelectorIMP(selfObject, originCMD, hidden, animated);
                }
            };
        });
        
        NXNavigationExtensionExtendImplementationOfVoidMethodWithoutArguments([UINavigationBar class], @selector(layoutSubviews), ^(__kindof UINavigationBar *_Nonnull selfObject) {
            UINavigationBarDidUpdatePropertiesHandler didUpdatePropertiesHandler = selfObject.nx_didUpdatePropertiesHandler;
            if (didUpdatePropertiesHandler) {
                didUpdatePropertiesHandler(selfObject);
            }
        });
        
        NXNavigationExtensionOverrideImplementation([UINavigationBar class], @selector(setUserInteractionEnabled:), ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, BOOL userInteractionEnabled) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                
                if (!selfObject.nx_userInteractionEnabled) {
                    originSelectorIMP(selfObject, originCMD, NO);
                    return;
                }
                originSelectorIMP(selfObject, originCMD, userInteractionEnabled);
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UINavigationBar class], @selector(setHidden:), ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, BOOL hidden) {
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, hidden);
                
                UINavigationBarDidUpdatePropertiesHandler didUpdatePropertiesHandler = selfObject.nx_didUpdatePropertiesHandler;
                if (didUpdatePropertiesHandler) {
                    didUpdatePropertiesHandler(selfObject);
                }
            };
        });
    });
}

#pragma mark - Getter & Setter

- (UINavigationBarDidUpdatePropertiesHandler)nx_didUpdatePropertiesHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_didUpdatePropertiesHandler:(UINavigationBarDidUpdatePropertiesHandler)nx_didUpdatePropertiesHandler {
    objc_setAssociatedObject(self, @selector(nx_didUpdatePropertiesHandler), nx_didUpdatePropertiesHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)nx_userInteractionEnabled {
    NSNumber *userInteractionEnabled = objc_getAssociatedObject(self, _cmd);
    if (userInteractionEnabled && [userInteractionEnabled isKindOfClass:[NSNumber class]]) {
        return [userInteractionEnabled boolValue];
    }
    return YES;
}

- (void)setNx_userInteractionEnabled:(BOOL)nx_userInteractionEnabled {
    objc_setAssociatedObject(self, @selector(nx_userInteractionEnabled), @(nx_userInteractionEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UINavigationController (NXNavigationExtensionInternal)

@property (nonatomic, assign) BOOL nx_prepareConfigurationCompleted;

@end

@implementation UINavigationController (NXNavigationExtensionInternal)

#pragma mark - Private

- (BOOL)nx_prepareConfigurationCompleted {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number && [number isKindOfClass:[NSNumber class]]) {
        return [number boolValue];
    }
    return NO;
}

- (void)setNx_prepareConfigurationCompleted:(BOOL)nx_prepareConfigurationCompleted {
    objc_setAssociatedObject(self, @selector(nx_prepareConfigurationCompleted), @(nx_prepareConfigurationCompleted), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (NXNavigatioVirtualWrapperViewFilterCallback)nx_filterNavigationVirtualWrapperViewCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_filterNavigationVirtualWrapperViewCallback:(NXNavigatioVirtualWrapperViewFilterCallback)nx_filterNavigationVirtualWrapperViewCallback {
    objc_setAssociatedObject(self, @selector(nx_filterNavigationVirtualWrapperViewCallback), nx_filterNavigationVirtualWrapperViewCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NXScreenEdgePopGestureRecognizerDelegate *)nx_screenEdgePopGestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_screenEdgePopGestureDelegate:(NXScreenEdgePopGestureRecognizerDelegate *_Nonnull)nx_screenEdgePopGestureDelegate {
    objc_setAssociatedObject(self, @selector(nx_screenEdgePopGestureDelegate), nx_screenEdgePopGestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NXFullScreenPopGestureRecognizerDelegate *)nx_fullScreenPopGestureDelegate {
    NXFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate && [delegate isKindOfClass:[NXFullScreenPopGestureRecognizerDelegate class]]) {
        return delegate;
    }
    delegate = [[NXFullScreenPopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return delegate;
}

- (NXNavigationRouter *)nx_navigationRouter API_AVAILABLE(ios(13.0)) {
    NXNavigationRouter *navigationRouter = objc_getAssociatedObject(self, _cmd);
    if (!navigationRouter) {
        navigationRouter = [[NXNavigationRouter alloc] init];
        objc_setAssociatedObject(self, _cmd, navigationRouter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navigationRouter;
}

// Override
- (NXNavigationConfiguration *)nx_configuration {
    NXNavigationConfiguration *configuration = objc_getAssociatedObject(self, _cmd);
    if (!configuration && !self.nx_prepareConfigurationCompleted) {
        self.nx_prepareConfigurationCompleted = YES;
        configuration = [NXNavigationConfiguration configurationFromNavigationControllerClass:[self class]];
        NXNavigationControllerPrepareConfigurationCallback callback = [NXNavigationConfiguration prepareConfigurationCallbackFromNavigationControllerClass:[self class]];
        if (callback) {
            configuration = callback(self, [configuration copy]);
        }
        [self setNx_configuration:configuration];
    }
    return configuration;
}

- (BOOL)nx_useNavigationBar {
    return self.nx_configuration != nil;
}

- (void)nx_configureNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];
    
    self.nx_screenEdgePopGestureDelegate = [[NXScreenEdgePopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    self.interactivePopGestureRecognizer.delegate = self.nx_screenEdgePopGestureDelegate;
}

- (void)nx_configureFullScreenPopGesture {
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.nx_fullScreenPopGestureRecognizer]) {
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.nx_fullScreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.nx_fullScreenPopGestureRecognizer.delegate = self.nx_fullScreenPopGestureDelegate;
        [self.nx_fullScreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.nx_fullScreenPopGestureRecognizer];
    }
}

- (id)nx_triggerSystemPopViewController:(__kindof UIViewController *)destinationViewController
                        interactiveType:(NXNavigationInteractiveType)interactiveType
                                handler:(id (^)(UINavigationController *navigationController))handler {
    if (self.viewControllers.count <= 1) return nil;
    
    UIViewController *topViewController = self.topViewController;
    if (self.nx_useNavigationBar && topViewController) {
        UIViewController *viewController = destinationViewController ?: topViewController;
        if ([self nx_viewController:topViewController preparePopViewController:viewController interactiveType:interactiveType]) {
            return handler(topViewController.navigationController);
        }
    } else {
        return handler(topViewController.navigationController);
    }
    return nil;
}

- (BOOL)nx_checkFullScreenInteractivePopGestureEnabledWithViewController:(__kindof UIViewController *)viewController {
    if (self.nx_fullScreenInteractivePopGestureEnabled) {
        return viewController.nx_enableFullScreenInteractivePopGesture;
    }
    return viewController.nx_enableFullScreenInteractivePopGesture;
}

- (void)nx_adjustmentSystemBackButtonForViewController:(__kindof UIViewController *)currentViewController inViewControllers:(NSArray<__kindof UIViewController *> *)previousViewControllers {
    __kindof UIViewController *lastViewController = previousViewControllers.lastObject;
    if (lastViewController && lastViewController != currentViewController && currentViewController.nx_useSystemBackButton) {
        if (currentViewController.nx_systemBackButtonTitle) {
            // 去掉前后空格
            NSString *title = [currentViewController.nx_systemBackButtonTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
            if ([title isEqualToString:@""]) {
                if (@available(iOS 14.0, *)) {
                    /**
                     * #1
                     * lastViewController.navigationItem.backBarButtonItem = nil; 恢复系统返回按钮默认样式。长按返回按钮还会出现上一级导航栏的标题
                     * lastViewController.navigationItem.backButtonDisplayMode = UINavigationItemBackButtonDisplayModeMinimal; 隐藏返回按钮标题
                     * #2
                     * UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]; // 隐藏返回按钮标题
                     * lastViewController.navigationItem.backBarButtonItem = backItem; 长按返回按钮将无法出现上一级导航栏的标题
                     */
                    lastViewController.navigationItem.backBarButtonItem = nil;
                    lastViewController.navigationItem.backButtonDisplayMode = UINavigationItemBackButtonDisplayModeMinimal;
                } else {
                    lastViewController.navigationItem.backBarButtonItem = backItem;
                }
            } else {
                // 自定义返回按钮标题
                lastViewController.navigationItem.backBarButtonItem = backItem;
            }
        } else {
            // 恢复系统返回按钮默认样式
            lastViewController.navigationItem.backBarButtonItem = nil;
        }
    }
}

- (BOOL)nx_viewController:(__kindof UIViewController *)currentViewController preparePopViewController:(__kindof UIViewController *)destinationViewController interactiveType:(NXNavigationInteractiveType)interactiveType {
    if ([currentViewController.nx_navigationInteractDelegate respondsToSelector:@selector(nx_navigationController:willPopViewController:interactiveType:)]) {
        return [currentViewController.nx_navigationInteractDelegate nx_navigationController:self willPopViewController:destinationViewController interactiveType:interactiveType];
    } else if ([currentViewController respondsToSelector:@selector(nx_navigationController:willPopViewController:interactiveType:)]) {
        return [currentViewController nx_navigationController:self willPopViewController:destinationViewController interactiveType:interactiveType];
    }
    return YES;
}

@end


@interface UIViewController (NXNavigationExtensionInternal)

/// 记录自定义返回按钮对象，用于后续对比是否为同一个对象
@property (nonatomic, strong) UIBarButtonItem *nx_customBackButtonItem;

@end


@implementation UIViewController (NXNavigationExtensionInternal)

- (BOOL)nx_isRootViewController {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number && [number isKindOfClass:[NSNumber class]]) {
        return [number boolValue];
    }
    return NO;
}

- (void)setNx_isRootViewController:(BOOL)nx_isRootViewController {
    objc_setAssociatedObject(self, @selector(nx_isRootViewController), @(nx_isRootViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 保证 self.navigationController 不为 nil，不要直接调研 navigationController 方法
- (void)nx_triggerSystemPopViewController {
    if (self.navigationController) {
        NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
        UIViewController *destinationViewController = (viewControllers && viewControllers.count > 1) ? viewControllers[viewControllers.count - 2] : nil;
        [self.navigationController nx_triggerSystemPopViewController:destinationViewController
                                                     interactiveType:NXNavigationInteractiveTypeBackButtonAction
                                                             handler:^id _Nonnull(UINavigationController *_Nonnull navigationController) {
            return [navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (UIBarButtonItem *)nx_customBackButtonItem {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_customBackButtonItem:(UIBarButtonItem *)nx_customBackButtonItem {
    objc_setAssociatedObject(self, @selector(nx_customBackButtonItem), nx_customBackButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<NXNavigationInteractable>)nx_navigationInteractDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_navigationInteractDelegate:(id<NXNavigationInteractable>)nx_navigationInteractDelegate {
    objc_setAssociatedObject(self, @selector(nx_navigationInteractDelegate), nx_navigationInteractDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (NXNavigationConfiguration *)nx_configuration {
    NXNavigationConfiguration *configuration = objc_getAssociatedObject(self, _cmd);
    if (!configuration && self.navigationController) {
        configuration = self.navigationController.nx_configuration;
        [self setNx_configuration:configuration];
    }
    return configuration;
}

- (void)setNx_configuration:(NXNavigationConfiguration *)nx_configuration {
    // copy 一次，保证每个页面之间的配置互不影响
    objc_setAssociatedObject(self, @selector(nx_configuration), [nx_configuration copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NXViewControllerPrepareConfigurationCallback)nx_prepareConfigureViewControllerCallback {
    NXViewControllerPrepareConfigurationCallback callback = objc_getAssociatedObject(self, _cmd);
    if (!callback && self.navigationController && self.navigationController.nx_useNavigationBar) {
        callback = self.navigationController.nx_prepareConfigureViewControllerCallback;
        [self setNx_prepareConfigureViewControllerCallback:callback];
    }
    return callback;
}

- (void)setNx_prepareConfigureViewControllerCallback:(NXViewControllerPrepareConfigurationCallback)nx_prepareConfigureViewControllerCallback {
    objc_setAssociatedObject(self, @selector(nx_prepareConfigureViewControllerCallback), nx_prepareConfigureViewControllerCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)nx_configureNavigationBarWithNavigationController:(__kindof UINavigationController *)navigationController {
    [self.navigationItem setHidesBackButton:!self.nx_useSystemBackButton animated:NO];
    if (self.nx_useSystemBackButton) {
        UIBarButtonItem *customBackButtonItem = self.nx_customBackButtonItem;
        UIBarButtonItem *leftBarButtonItem = self.navigationItem.leftBarButtonItem;
        // 如果导航栏不同时支持返回按钮和 leftItems 则清空 left 区域，或者 left 为自定义返回按钮也要清空。
        if (!self.navigationItem.leftItemsSupplementBackButton ||
            (customBackButtonItem && leftBarButtonItem && customBackButtonItem == leftBarButtonItem)) {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItems = nil;
        }
        return;
    }
    
    UIBarButtonItem *backButtonItem = self.navigationItem.leftBarButtonItem;
    UIView *customView = self.nx_backButtonCustomView;
    if (customView) {
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nx_triggerSystemPopViewController)];
        customView.userInteractionEnabled = YES;
        [customView addGestureRecognizer:tap];
        self.nx_customBackButtonItem = backButtonItem;
    } else {
        UIImage *backImage = self.nx_backImage;
        UIImage *landscapeBackImage = self.nx_backImage;
        backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage landscapeImagePhone:landscapeBackImage style:UIBarButtonItemStylePlain target:self action:@selector(nx_triggerSystemPopViewController)];
        backButtonItem.imageInsets = navigationController.nx_backImageInsets;
        backButtonItem.landscapeImagePhoneInsets = navigationController.nx_landscapeBackImageInsets;
        self.nx_customBackButtonItem = backButtonItem;
    }
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

@end
