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

@implementation UINavigationController (UINavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UINavigationController class], @selector(pushViewController:animated:), @selector(ue_pushViewController:animated:));
        UINavigationExtensionSwizzleMethod([UINavigationController class], @selector(setViewControllers:animated:), @selector(ue_setViewControllers:animated:));
    });
}

+ (BOOL)ue_fullscreenPopGestureEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number && [number isKindOfClass:[NSNumber class]]) {
        return [number boolValue];
    }
    return NO;
}

+ (void)setUe_fullscreenPopGestureEnabled:(BOOL)ue_fullscreenPopGestureEnabled {
    NSNumber *number = [NSNumber numberWithBool:ue_fullscreenPopGestureEnabled];
    objc_setAssociatedObject(self, @selector(ue_fullscreenPopGestureEnabled), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ue_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.ue_useNavigationBar) {
        if (self.viewControllers.count > 0) {
            [viewController ue_configureNavigationBarItem];
        }
        
        if (viewController.ue_enableFullScreenInteractivePopGesture) {
            [self ue_configureFullscreenPopGesture];
        }
    }
    
    [self ue_pushViewController:viewController animated: animated];
}

- (void)ue_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (self.ue_useNavigationBar) {
        if (viewControllers.count > 1) {
            for (NSUInteger index = 0; index < viewControllers.count; index++) {
                UIViewController *viewController = viewControllers[index];
                if (index != 0) {
                    [viewController ue_configureNavigationBarItem];
                }
                
                if (viewController.ue_enableFullScreenInteractivePopGesture) {
                    [self ue_configureFullscreenPopGesture];
                }
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
- (void)ue_configureFullscreenPopGesture {
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

- (NSArray *)ue_findViewControllerClass:(Class)aClass createViewControllerUsingBlock:(__kindof UIViewController * (^ __nullable)(void))block {
    NSArray<__kindof UIViewController *> *viewControllers = self.viewControllers;
    if (!aClass || (viewControllers.count <= 1)) return viewControllers;
    
    NSMutableArray<__kindof UIViewController *> *collections = [NSMutableArray array];
    __kindof UIViewController *lastViewController = self.viewControllers.lastObject;
    for (__kindof UIViewController *viewController in viewControllers) {
        [collections addObject:viewController];
        if ([NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass(aClass)]) {
            if ([NSStringFromClass([lastViewController class]) isEqualToString:NSStringFromClass(aClass)]) {
                if (viewController != lastViewController) { // 处理最后一个 ViewController 已经在界面显示的情况
                    [collections addObject:lastViewController];
                }
                return collections;
            } else {
                [collections addObject:lastViewController];
                return collections;
            }
        } else {
            if (viewController == lastViewController && block) {
                __kindof UIViewController *newViewController = block();
                if (newViewController) {
                    [collections insertObject:newViewController atIndex:viewControllers.count - 1];
                    return collections;
                }
            }
        }
    }
    return viewControllers;
}

#pragma mark - Getter & Setter
- (UIPanGestureRecognizer *)ue_fullscreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureRecognizer && [panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return panGestureRecognizer;
    }
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return panGestureRecognizer;
}

#pragma mark - Public
- (void)ue_triggerSystemBackButtonHandler {
    if (self.viewControllers.count <= 1) return;
    
    UIViewController *topViewController = self.topViewController;
    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willPopViewControllerUsingInteractiveGesture:)]) {
        if ([(id<UINavigationControllerCustomizable>)topViewController navigationController:self willPopViewControllerUsingInteractiveGesture:NO]) {
            [topViewController.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [topViewController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)ue_redirectViewControllerClass:(Class)aClass createViewControllerUsingBlock:(__kindof UIViewController * _Nonnull (^)(void))block {
    NSArray<__kindof UIViewController *> *viewControllers = [self ue_findViewControllerClass:aClass createViewControllerUsingBlock:block];
    [self setViewControllers:viewControllers animated:YES];
}

@end
