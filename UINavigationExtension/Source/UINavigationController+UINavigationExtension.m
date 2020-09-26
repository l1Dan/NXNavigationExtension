//
//  UINavigationController+UINavigationExtension.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

// https://github.com/forkingdog/FDFullscreenPopGesture
// https://github.com/l1Dan/NSLNavigationSolution

#import "UINavigationController+UINavigationExtension.h"
#import "UIViewController+UINavigationExtension.h"
#import "UINavigationExtensionMacro.h"

BOOL UINavigationExtensionFullscreenPopGestureEnable = NO;

@interface _UENavigationGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _UENavigationGestureRecognizerDelegate

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
    if (topViewController && topViewController.ue_interactivePopGestureDisable) {
        return NO;
    }

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willJumpToViewControllerUsingInteractivePopGesture:)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self.navigationController willJumpToViewControllerUsingInteractivePopGesture:YES];
    }
    
    return YES;
}

@end

@interface _UEFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _UEFullscreenPopGestureRecognizerDelegate

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
    if (!topViewController.ue_enableFullScreenInteractivePopGesture) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.ue_interactivePopMaxAllowedDistanceToLeftEdge;
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
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willJumpToViewControllerUsingInteractivePopGesture:)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self.navigationController willJumpToViewControllerUsingInteractivePopGesture:YES];
    }
    
    return YES;
}

@end

@interface UINavigationController (UINavigationExtension)

@property (nonatomic, strong) _UENavigationGestureRecognizerDelegate *ue_gestureDelegate;
@property (nonatomic, strong) _UEFullscreenPopGestureRecognizerDelegate *ue_fullscreenPopGestureDelegate;

@end

@implementation UINavigationController (UINavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UINavigationController class], @selector(pushViewController:animated:), @selector(ue_pushViewController:animated:));
        UINavigationExtensionSwizzleMethod([UINavigationController class], @selector(setViewControllers:animated:), @selector(ue_setViewControllers:animated:));
    });
}

- (void)ue_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        [self configureNavigationBarItemInViewController:viewController];
    }
    
    if (viewController.ue_enableFullScreenInteractivePopGesture) {
        [self enableFullscreenPopGesture];
    }
    
    [self ue_pushViewController:viewController animated: animated];
}

- (void)ue_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (viewControllers.count > 1) {
        NSArray<__kindof UIViewController *> *viewControllers = [self.viewControllers.reverseObjectEnumerator allObjects];
        for (NSUInteger index = 0; index < viewControllers.count; index++) {
            UIViewController *viewController = viewControllers[index];
            if (index != 0) {
                [self configureNavigationBarItemInViewController:viewController];
            }
            
            if (viewController.ue_enableFullScreenInteractivePopGesture) {
                [self enableFullscreenPopGesture];
            }
        }
    }
    
    [self ue_setViewControllers:viewControllers animated: animated];
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

#pragma mark - Private
- (void)configureNavigationBarItemInViewController:(__kindof UIViewController *)viewController {
    UIBarButtonItem *backButtonItem;
    UIView *customView = viewController.ue_backButtonCustomView;
    if (customView) {
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ue_triggerSystemBackButtonHandle)];
        customView.userInteractionEnabled = YES;
        [customView addGestureRecognizer:tap];
    } else {
        UIImage *backImage = viewController.ue_backImage;
        backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(ue_triggerSystemBackButtonHandle)];
    }
    viewController.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)enableFullscreenPopGesture {
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.ue_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.ue_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.ue_fullscreenPopGestureRecognizer.delegate = self.ue_fullscreenPopGestureDelegate;
        [self.ue_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.ue_fullscreenPopGestureRecognizer];
    }
}

- (NSArray *)findViewController:(Class)className usingCreateViewControllerHandler:(__kindof UIViewController * (^)(void))handler {
    /*  导航栏查找规则：
     1. 如果传入 viewController 存在于 viewControllers 中，则使用 viewControllers 中的以及存在的。
     2. 如果传入 viewController 不存在 viewControllers 中，则使用传入的 viewController。
     */
    
    NSMutableArray<__kindof UIViewController *> *newViewControllers = [NSMutableArray array];
    NSArray<__kindof UIViewController *> *oldViewControllers = self.viewControllers;
    for (__kindof UIViewController *viewController in oldViewControllers) {
        [newViewControllers addObject:viewController];
        if ([NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass(className)]) {
            return newViewControllers;
        } else {
            if (newViewControllers.count == oldViewControllers.count) {
                if (handler) {
                    __kindof UIViewController *createViewController = handler();
                    [newViewControllers addObject:createViewController];
                    return newViewControllers;
                }
            }
        }
    }
    return newViewControllers;
}

#pragma mark - Getter & Setter
- (_UENavigationGestureRecognizerDelegate *)ue_gestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_gestureDelegate:(_UENavigationGestureRecognizerDelegate *)ue_gestureDelegate {
    objc_setAssociatedObject(self, @selector(ue_gestureDelegate), ue_gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_UEFullscreenPopGestureRecognizerDelegate *)ue_fullscreenPopGestureDelegate {
    _UEFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate && [delegate isKindOfClass:[_UEFullscreenPopGestureRecognizerDelegate class]]) {
        return delegate;
    }
    delegate = [[_UEFullscreenPopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return delegate;
}

- (BOOL)ue_useNavigationBar {
    NSNumber *navigationBarEnable = objc_getAssociatedObject(self, _cmd);
    if (navigationBarEnable && [navigationBarEnable isKindOfClass:[NSNumber class]]) {
        return [navigationBarEnable boolValue];
    }
    return YES;
}

- (void)setUe_navigationBarEnable:(BOOL)ue_useNavigationBar {
    objc_setAssociatedObject(self, @selector(ue_useNavigationBar), [NSNumber numberWithBool:ue_useNavigationBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ue_triggerSystemBackButtonHandle {
    if (self.viewControllers.count <= 1) return;
    
    UIViewController *topViewController = self.topViewController;
    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willJumpToViewControllerUsingInteractivePopGesture:)]) {
        if ([(id<UINavigationControllerCustomizable>)topViewController navigationController:self willJumpToViewControllerUsingInteractivePopGesture:NO]) {
            [topViewController ue_triggerSystemBackButtonHandle];
        }
    } else {
        [self.topViewController ue_triggerSystemBackButtonHandle];
    }
}

#pragma mark - Public
- (UIPanGestureRecognizer *)ue_fullscreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureRecognizer && [panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return panGestureRecognizer;
    }
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return panGestureRecognizer;
}

- (void)configureNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];
    
    self.ue_gestureDelegate = [[_UENavigationGestureRecognizerDelegate alloc] initWithNavigationController:self];
    self.interactivePopGestureRecognizer.delegate = self.ue_gestureDelegate;
}

- (void)ue_jumpViewControllerClass:(Class)className usingCreateViewControllerHandler:(__kindof UIViewController * _Nonnull (^)(void))handler {
    NSArray<__kindof UIViewController *> *viewControllers = [self findViewController:className usingCreateViewControllerHandler:handler];
    [self setViewControllers:viewControllers animated:YES];
}

@end
