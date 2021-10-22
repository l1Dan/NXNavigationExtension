//
// UINavigationController+NXNavigationExtension.m
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

// https://github.com/forkingdog/FDFullscreenPopGesture
// https://github.com/l1Dan/NSLNavigationSolution

#import "NXNavigationConfiguration.h"
#import "NXNavigationExtensionPrivate.h"
#import "NXNavigationExtensionRuntime.h"
#import "UIViewController+NXNavigationExtension.h"


@implementation UINavigationController (NXNavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            NXNavigationExtensionOverrideImplementation(NSClassFromString([NSString nx_stringByConcat:@"_", @"UINavigationBar", @"ContentView", nil]), NSSelectorFromString(@"__backButtonAction:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(UIView *selfObject, id firstArgv) {
                    if ([selfObject.superview isKindOfClass:UINavigationBar.class]) {
                        UINavigationBar *bar = (UINavigationBar *)selfObject.superview;
                        if ([bar.delegate isKindOfClass:UINavigationController.class]) {
                            UINavigationController *navigationController = (UINavigationController *)bar.delegate;
                            UIViewController *topViewController = navigationController.topViewController;
                            NSArray<UIViewController *> *viewControllers = navigationController.viewControllers;
                            UIViewController *destinationViewController = (viewControllers && viewControllers.count >= 2) ? viewControllers[viewControllers.count - 2] : topViewController;
                            if (navigationController.nx_useNavigationBar && topViewController) {
                                if (![navigationController nx_viewController:topViewController preparePopViewController:destinationViewController interactiveType:NXNavigationInteractiveTypeBackButtonAction]) {
                                    return;
                                }
                            }
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, id);
                    originSelectorIMP = (void (*)(id, SEL, id))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
            
            NXNavigationExtensionOverrideImplementation([UINavigationController class], NSSelectorFromString(@"_tryRequestPopToItem:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^BOOL(UINavigationController *selfObject, UINavigationItem *item) {
                    UIViewController *topViewController = selfObject.topViewController;
                    if (selfObject.nx_useNavigationBar && topViewController) {
                        UIViewController *destinationViewController = topViewController;
                        for (UIViewController *viewController in selfObject.viewControllers) {
                            if (viewController.navigationItem == item) {
                                destinationViewController = viewController;
                            }
                        }
                        
                        if (![selfObject nx_viewController:topViewController preparePopViewController:destinationViewController interactiveType:NXNavigationInteractiveTypeBackButtonMenuAction]) {
                            return NO;
                        }
                    }
                    
                    // call super
                    BOOL (*originSelectorIMP)(id, SEL, id);
                    originSelectorIMP = (BOOL (*)(id, SEL, id))originalIMPProvider();
                    return originSelectorIMP(selfObject, originCMD, item);
                };
            });
        }
        
        NXNavigationExtensionOverrideImplementation([UINavigationController class], @selector(pushViewController:animated:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                if (selfObject.nx_useNavigationBar) {
                    viewController.navigationItem.nx_viewController = viewController;
                    // 先赋值一次
                    viewController.nx_configuration = selfObject.nx_configuration;
                    viewController.nx_prepareConfigureViewControllerCallback = selfObject.nx_prepareConfigureViewControllerCallback;
                    // 设置返回按钮
                    [selfObject nx_adjustmentSystemBackButtonForViewController:viewController inViewControllers:selfObject.viewControllers];
                    
                    if (selfObject.viewControllers.count > 0) {
                        [viewController nx_configureNavigationBarWithNavigationController:selfObject];
                    }
                    
                    if ([selfObject nx_checkFullscreenInteractivePopGestureEnabledWithViewController:viewController]) {
                        [selfObject nx_configureFullscreenPopGesture];
                    }
                }
                
                void (*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                originSelectorIMP = (void (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, viewController, animated);
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UINavigationController class], @selector(setViewControllers:animated:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, NSArray<UIViewController *> *viewControllers, BOOL animated) {
                if (selfObject.nx_useNavigationBar) {
                    for (UIViewController *viewController in viewControllers) {
                        viewController.navigationItem.nx_viewController = viewController;
                        // 先赋值一次
                        viewController.nx_configuration = selfObject.nx_configuration;
                        viewController.nx_prepareConfigureViewControllerCallback = selfObject.nx_prepareConfigureViewControllerCallback;
                    }
                    
                    if (viewControllers.count > 1) {
                        NSMutableArray<__kindof UIViewController *> *previousViewControllers = [NSMutableArray array];
                        for (NSUInteger index = 0; index < viewControllers.count; index++) {
                            UIViewController *viewController = viewControllers[index];
                            
                            if (index != 0) {
                                // 设置返回按钮
                                [selfObject nx_adjustmentSystemBackButtonForViewController:viewController inViewControllers:previousViewControllers];
                                [viewController nx_configureNavigationBarWithNavigationController:selfObject];
                            }
                            [previousViewControllers addObject:viewController];
                            
                            if ([selfObject nx_checkFullscreenInteractivePopGestureEnabledWithViewController:viewController]) {
                                [selfObject nx_configureFullscreenPopGesture];
                            }
                        }
                    }
                }
                
                void (*originSelectorIMP)(id, SEL, NSArray<UIViewController *> *, BOOL);
                originSelectorIMP = (void (*)(id, SEL, NSArray<UIViewController *> *, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, viewControllers, animated);
            };
        });
    });
}

- (NSArray *)nx_findViewControllerClass:(Class)aClass initializeStandbyViewControllerUsingBlock:(__kindof UIViewController * (^ __nullable)(void))block {
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

- (BOOL)nx_fullscreenInteractivePopGestureEnabled {
    return self.nx_configuration.navigationControllerPreferences.fullscreenInteractivePopGestureEnabled;
}

- (UIPanGestureRecognizer *)nx_fullscreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureRecognizer && [panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return panGestureRecognizer;
    }
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return panGestureRecognizer;
}

#pragma mark - Public

- (UIViewController *)nx_popViewControllerAnimated:(BOOL)animated {
    NSArray<UIViewController *> *viewControllers = self.viewControllers;
    UIViewController *destinationViewController = (viewControllers && viewControllers.count > 1) ? viewControllers[viewControllers.count - 2] : nil;
    return [self nx_triggerSystemPopViewController:destinationViewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
                                           handler:^id _Nonnull(UINavigationController * _Nonnull navigationController) {
        return [navigationController popViewControllerAnimated:animated];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self nx_triggerSystemPopViewController:viewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
                                           handler:^id _Nonnull(UINavigationController * _Nonnull navigationController) {
        return [navigationController popToViewController:viewController animated:animated];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *destinationViewController = self.viewControllers.firstObject;
    return [self nx_triggerSystemPopViewController:destinationViewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
                                           handler:^id _Nonnull(UINavigationController * _Nonnull navigationController) {
        return [navigationController popToRootViewControllerAnimated:animated];
    }];
}

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerUsingBlock:(__kindof UIViewController * _Nullable (^)(void))block {
    NSArray<__kindof UIViewController *> *viewControllers = [self nx_findViewControllerClass:aClass initializeStandbyViewControllerUsingBlock:block];
    [self setViewControllers:viewControllers animated:YES];
}

@end
