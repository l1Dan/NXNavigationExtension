//
// UINavigationController+UINavigationExtension.m
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

// https://github.com/forkingdog/FDFullscreenPopGesture
// https://github.com/l1Dan/NSLNavigationSolution

#import "UINavigationController+UINavigationExtension.h"
#import "UIViewController+UINavigationExtension.h"
#import "UINavigationExtensionMacro.h"
#import "UINavigationExtensionPrivate.h"

BOOL UINavigationExtensionFullscreenPopGestureEnable = NO;

@implementation UINavigationController (UINavigationExtension)

+ (void)ue_registerForNavigationControllerClass:(Class)aClass {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod(aClass, @selector(pushViewController:animated:), @selector(ue_pushViewController:animated:));
        UINavigationExtensionSwizzleMethod(aClass, @selector(setViewControllers:animated:), @selector(ue_setViewControllers:animated:));
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

- (UIPanGestureRecognizer *)ue_fullscreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureRecognizer && [panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return panGestureRecognizer;
    }
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return panGestureRecognizer;
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
- (void)ue_jumpViewControllerClass:(Class)className usingCreateViewControllerHandler:(__kindof UIViewController * _Nonnull (^)(void))handler {
    NSArray<__kindof UIViewController *> *viewControllers = [self findViewController:className usingCreateViewControllerHandler:handler];
    [self setViewControllers:viewControllers animated:YES];
}

+ (void)registerViewControllerClass:(Class)firstClass forNavigationBarClass:(Class)secondClass {
    NSParameterAssert(firstClass);
    NSParameterAssert(secondClass);
    
    if (![[firstClass new] isKindOfClass:[UINavigationController class]] &&
        [[firstClass new] isKindOfClass:[UIViewController class]] &&
        [[secondClass new] isKindOfClass:[UINavigationBar class]]) {
        [UINavigationController ue_registerForNavigationControllerClass:self];
        [UIViewController ue_registerForViewControllerClass:firstClass];
        [UINavigationBar ue_registerForNavigationBar:secondClass];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"类型错误！" userInfo:nil];
    }
}

@end
