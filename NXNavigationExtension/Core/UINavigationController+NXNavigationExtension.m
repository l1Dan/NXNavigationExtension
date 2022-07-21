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

#import "NXNavigationExtensionInternal.h"
#import "NXNavigationExtensionRuntime.h"

#import "UINavigationController+NXNavigationExtension.h"


@implementation UINavigationController (NXNavigationExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14.0, *)) {
            NXNavigationExtensionOverrideImplementation(NSClassFromString([NSString nx_stringByConcat:@"_", @"UINavigationBar", @"ContentView", nil]),
                                                        NSSelectorFromString(@"__backButtonAction:"),
                                                        ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
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
            
            NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                        NSSelectorFromString(@"_tryRequestPopToItem:"),
                                                        ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
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
                    originSelectorIMP = (BOOL(*)(id, SEL, id))originalIMPProvider();
                    return originSelectorIMP(selfObject, originCMD, item);
                };
            });
        }
        
        NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                    @selector(pushViewController:animated:),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                // call super
                void (^callSuperBlock)(void) = ^{
                    void (*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                    originSelectorIMP = (void (*)(id, SEL, UIViewController *, BOOL))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, viewController, animated);
                };
                
                if (!selfObject.nx_useNavigationBar) {
                    callSuperBlock();
                    return;
                }
                
                if (selfObject.presentedViewController) {
                    NXDebugLog(@"push 的时候 UINavigationController 存在一个盖在上面的 presentedViewController，可能导致一些 UINavigationControllerDelegate 不会被调用");
                }
                
                if ([selfObject.viewControllers containsObject:viewController]) {
                    NXDebugLog(@"不允许重复 push 相同的 viewController 实例，会产生 crash。当前 viewController：%@", viewController);
                    return;
                }
                
                BOOL willPushActually = viewController && ![viewController isKindOfClass:UITabBarController.class] && ![selfObject.viewControllers containsObject:viewController];
                if (!willPushActually) {
                    callSuperBlock();
                    return;
                }
                
                viewController.navigationItem.nx_viewController = viewController;
                // 先赋值一次
                viewController.nx_configuration = selfObject.nx_configuration;
                viewController.nx_prepareConfigureViewControllerCallback = selfObject.nx_prepareConfigureViewControllerCallback;
                // 设置返回按钮
                [selfObject nx_adjustmentSystemBackButtonForViewController:viewController inViewControllers:selfObject.viewControllers];
                
                if (selfObject.viewControllers.count > 0) {
                    [viewController nx_configureNavigationBarWithNavigationController:selfObject];
                }
                // 重新检查返回手势是否动态修改
                [selfObject nx_configureInteractivePopGestureRecognizerWithViewController:viewController];
                
                UIViewController *appearingViewController = viewController;
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionWillPush];
                
                callSuperBlock();
                
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionDidPush];
                
                [selfObject nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    NXNavigationAction navigationAction = context.isCancelled ? NXNavigationActionPushCancelled : NXNavigationActionPushCompleted;
                    [selfObject nx_processViewController:appearingViewController navigationAction:navigationAction];
                    [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionUnspecified];
                }];
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                    @selector(popViewControllerAnimated:),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^UIViewController *(UINavigationController *selfObject, BOOL animated) {
                // call super
                UIViewController * (^callSuperBlock)(void) = ^UIViewController *(void) {
                    UIViewController *(*originSelectorIMP)(id, SEL, BOOL);
                    originSelectorIMP = (UIViewController * (*)(id, SEL, BOOL)) originalIMPProvider();
                    UIViewController *result = originSelectorIMP(selfObject, originCMD, animated);
                    return result;
                };
                
                if (!selfObject.nx_useNavigationBar) {
                    return callSuperBlock();
                }
                
                NXNavigationAction action = selfObject.nx_navigationAction;
                if (action != NXNavigationActionUnspecified) {
                    NXDebugLog(@"popViewController 时上一次的转场尚未完成，系统会忽略本次 pop，等上一次转场完成后再重新执行 pop, viewControllers = %@", selfObject.viewControllers);
                }
                
                // 系统文档里说 rootViewController 是不能被 pop 的，当只剩下 rootViewController 时当前方法什么事都不会做
                BOOL willPopActually = selfObject.viewControllers.count > 1 && action == NXNavigationActionUnspecified;
                if (!willPopActually) {
                    return callSuperBlock();
                }
                
                UIViewController *appearingViewController = selfObject.viewControllers[selfObject.viewControllers.count - 2];
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionWillPop];
                
                UIViewController *result = callSuperBlock();
                
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionDidPop];
                [selfObject nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    NXNavigationAction navigationAction = context.isCancelled ? NXNavigationActionPopCancelled : NXNavigationActionPopCompleted;
                    [selfObject nx_processViewController:appearingViewController navigationAction:navigationAction];
                    [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionUnspecified];
                }];
                
                return result;
            };
        });
        
        NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                    @selector(popToViewController:animated:),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> *(UINavigationController *selfObject, UIViewController *viewController, BOOL animated) {
                // call super
                NSArray<UIViewController *> * (^callSuperBlock)(void) = ^NSArray<UIViewController *> *(void) {
                    NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, UIViewController *, BOOL);
                    originSelectorIMP = (NSArray<UIViewController *> * (*)(id, SEL, UIViewController *, BOOL)) originalIMPProvider();
                    NSArray<UIViewController *> *disappearingViewControllers = originSelectorIMP(selfObject, originCMD, viewController, animated);
                    return disappearingViewControllers;
                };
                
                if (!selfObject.nx_useNavigationBar) {
                    return callSuperBlock();
                }
                
                NXNavigationAction action = selfObject.nx_navigationAction;
                if (action != NXNavigationActionUnspecified) {
                    NXDebugLog(@"popToViewController 时上一次的转场尚未完成，系统会忽略本次 pop，等上一次转场完成后再重新执行 pop, currentViewControllers = %@, viewController = %@", selfObject.viewControllers, viewController);
                }
                
                // 系统文档里说 rootViewController 是不能被 pop 的，当只剩下 rootViewController 时当前方法什么事都不会做
                BOOL willPopActually = selfObject.viewControllers.count > 1 && [selfObject.viewControllers containsObject:viewController] && selfObject.topViewController != viewController && action == NXNavigationActionUnspecified;
                if (!willPopActually) {
                    return callSuperBlock();
                }
                
                UIViewController *appearingViewController = viewController;
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionWillPop];
                
                NSArray<UIViewController *> *result = callSuperBlock();
                
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionDidPop];
                [selfObject nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    NXNavigationAction navigationAction = context.isCancelled ? NXNavigationActionPopCancelled : NXNavigationActionPopCompleted;
                    [selfObject nx_processViewController:appearingViewController navigationAction:navigationAction];
                    [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionUnspecified];
                }];
                
                return result;
            };
        });

        NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                    @selector(popToRootViewControllerAnimated:),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^NSArray<UIViewController *> *(UINavigationController *selfObject, BOOL animated) {
                // call super
                NSArray<UIViewController *> * (^callSuperBlock)(void) = ^NSArray<UIViewController *> *(void) {
                    NSArray<UIViewController *> *(*originSelectorIMP)(id, SEL, BOOL);
                    originSelectorIMP = (NSArray<UIViewController *> * (*)(id, SEL, BOOL)) originalIMPProvider();
                    NSArray<UIViewController *> *result = originSelectorIMP(selfObject, originCMD, animated);
                    return result;
                };

                if (!selfObject.nx_useNavigationBar) {
                    return callSuperBlock();
                }

                NXNavigationAction action = selfObject.nx_navigationAction;
                if (action != NXNavigationActionUnspecified) {
                    NXDebugLog(@"popToRootViewController 时上一次的转场尚未完成，系统会忽略本次 pop，等上一次转场完成后再重新执行 pop, viewControllers = %@", selfObject.viewControllers);
                }

                BOOL willPopActually = selfObject.viewControllers.count > 1 && action == NXNavigationActionUnspecified;
                if (!willPopActually) {
                    return callSuperBlock();
                }

                UIViewController *appearingViewController = selfObject.viewControllers.firstObject;
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionWillPop];

                NSArray<UIViewController *> *result = callSuperBlock();

                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionDidPop];
                [selfObject nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    NXNavigationAction navigationAction = context.isCancelled ? NXNavigationActionPopCancelled : NXNavigationActionPopCompleted;
                    [selfObject nx_processViewController:appearingViewController navigationAction:navigationAction];
                    [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionUnspecified];
                }];

                return result;
            };
        });

        NXNavigationExtensionOverrideImplementation([UINavigationController class],
                                                    @selector(setViewControllers:animated:),
                                                    ^id _Nonnull(__unsafe_unretained Class _Nonnull originClass, SEL _Nonnull originCMD, IMP _Nonnull (^_Nonnull originalIMPProvider)(void)) {
            return ^(UINavigationController *selfObject, NSArray<UIViewController *> *viewControllers, BOOL animated) {
                // call super
                void (^callSuperBlock)(void) = ^{
                    void (*originSelectorIMP)(id, SEL, NSArray<UIViewController *> *, BOOL);
                    originSelectorIMP = (void (*)(id, SEL, NSArray<UIViewController *> *, BOOL))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, viewControllers, animated);
                };

                if (!selfObject.nx_useNavigationBar) {
                    callSuperBlock();
                    return;
                }

                if (viewControllers.count != [NSSet setWithArray:viewControllers].count) {
                    NXDebugLog(@"setViewControllers 数组里不允许出现重复元素：%@", viewControllers);
                    viewControllers = [NSOrderedSet orderedSetWithArray:viewControllers].array; // 这里会保留该 vc 第一次出现的位置不变
                }

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
                        // 重新检查返回手势是否动态修改
                        [selfObject nx_configureInteractivePopGestureRecognizerWithViewController:viewController];
                    }
                }

                // setViewControllers 执行前后 topViewController 没有变化，则赋值为 nil，表示没有任何界面有“重新显示”。
                UIViewController *appearingViewController = selfObject.topViewController != viewControllers.lastObject ? viewControllers.lastObject : nil;
                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionWillSet];

                callSuperBlock();

                [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionDidSet];
                [selfObject nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    NXNavigationAction navigationAction = context.isCancelled ? NXNavigationActionSetCancelled : NXNavigationActionSetCompleted;
                    [selfObject nx_processViewController:appearingViewController navigationAction:navigationAction];
                    [selfObject nx_processViewController:appearingViewController navigationAction:NXNavigationActionUnspecified];
                }];
            };
        });
    });
}

- (NSArray<UIViewController *> *)nx_rebuildStackWithViewControllerClass:(Class)aClass
                                                              isReverse:(BOOL)isReverse
                                                                  block:(__kindof UIViewController * (^__nullable)(void))block {
    NSMutableArray<__kindof UIViewController *> *tempViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    if (!aClass || (tempViewControllers.count <= 1)) return [NSArray arrayWithArray:tempViewControllers];
    
    // 当前界面显示的 ViewController
    __kindof UIViewController *topViewController = tempViewControllers.lastObject;
    // 排除当前界面显示的 ViewController
    [tempViewControllers removeLastObject];
    
    NSMutableArray<__kindof UIViewController *> *collections = [NSMutableArray array];
    NSArray<__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:tempViewControllers];
    if (isReverse) {
        collections = [NSMutableArray arrayWithArray:tempViewControllers];
        viewControllers = viewControllers.reverseObjectEnumerator.allObjects;
    }
    
    for (__kindof UIViewController *viewController in viewControllers) {
        // 添加
        if (!isReverse) [collections addObject:viewController];
        
        // 找到相同类型的 ViewController 就立即停止
        if ([NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass(aClass)]) {
            break;
        }
        // 没找到，已经到最后了
        if (viewController == viewControllers.lastObject && block) {
            __kindof UIViewController *appendsViewController = block();
            if (appendsViewController) {
                [collections addObject:appendsViewController];
                break;
            }
        }
        
        // 移除
        if (isReverse) [collections removeObject:viewController];
    }
    
    // 补上当前正在显示的 ViewController
    [collections addObject:topViewController];
    return [NSArray arrayWithArray:collections];
}

#pragma mark - Getter & Setter

- (void)nx_prepareConfigureViewControllersCallback:(NXViewControllerPrepareConfigurationCallback)callback {
    self.nx_prepareConfigureViewControllerCallback = callback;
}

- (void)nx_applyFilterNavigationVirtualWrapperViewRuleCallback:(NXNavigationVirtualWrapperViewFilterCallback)callback {
    self.nx_filterNavigationVirtualWrapperViewCallback = callback;
}

#pragma mark - Public

- (UIPanGestureRecognizer *)nx_fullScreenPopGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureRecognizer && [panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return panGestureRecognizer;
    }
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return panGestureRecognizer;
}


@end


@implementation UINavigationController (NXNavigationExtensionTransition)

- (void)nx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [self pushViewController:viewController animated:animated];
    if (completion) {
        [self nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            completion();
        }];
    }
}

- (UIViewController *)nx_popViewControllerAnimated:(BOOL)animated
                                        completion:(void (^)(void))completion {
    NSArray<UIViewController *> *viewControllers = self.viewControllers;
    UIViewController *destinationViewController = (viewControllers && viewControllers.count > 1) ? viewControllers[viewControllers.count - 2] : nil;
    return [self nx_triggerSystemPopViewController:destinationViewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
              animateAlongsideTransitionCompletion:completion
                                           handler:^id _Nonnull(UINavigationController *_Nonnull navigationController) {
        return [navigationController popViewControllerAnimated:animated];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                        animated:(BOOL)animated
                                                      completion:(void (^)(void))completion {
    return [self nx_triggerSystemPopViewController:viewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
              animateAlongsideTransitionCompletion:completion
                                           handler:^id _Nonnull(UINavigationController *_Nonnull navigationController) {
        return [navigationController popToViewController:viewController animated:animated];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerAnimated:(BOOL)animated
                                                                  completion:(void (^)(void))completion {
    UIViewController *destinationViewController = self.viewControllers.firstObject;
    return [self nx_triggerSystemPopViewController:destinationViewController
                                   interactiveType:NXNavigationInteractiveTypeCallNXPopMethod
              animateAlongsideTransitionCompletion:completion
                                           handler:^id _Nonnull(UINavigationController *_Nonnull navigationController) {
        return [navigationController popToRootViewControllerAnimated:animated];
    }];
}

- (UIViewController *)nx_popViewControllerWithPush:(UIViewController *)viewControllerToPush
                                          animated:(BOOL)animated
                                        completion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    return [self nx_popViewControllerAnimated:NO completion:^{
        [weakSelf nx_pushViewController:viewControllerToPush animated:animated completion:completion];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                        withPush:(UIViewController *)viewControllerToPush
                                                        animated:(BOOL)animated
                                                      completion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    return [self nx_popToViewController:viewController animated:NO completion:^{
        [weakSelf nx_pushViewController:viewControllerToPush animated:animated completion:completion];
    }];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerWithPush:(UIViewController *)viewControllerToPush
                                                                    animated:(BOOL)animated
                                                                  completion:(void (^)(void))completion {
    __weak typeof(self) weakSelf = self;
    return [self nx_popToRootViewControllerAnimated:NO completion:^{
        [weakSelf nx_pushViewController:viewControllerToPush animated:animated completion:completion];
    }];
}

- (void)nx_setViewControllers:(NSArray<UIViewController *> *)viewControllers
                     animated:(BOOL)animated
                   completion:(void (^)(void))completion {
    [self setViewControllers:viewControllers animated:animated];
    if (completion) {
        [self nx_animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            completion();
        }];
    }
}

- (void)nx_removeViewControllersUntilClass:(Class)aClass
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block {
    [self nx_removeViewControllersUntilClass:aClass
                 withNavigationStackPosition:NXNavigationStackPositionLast
        insertsToBelowWhenNotFoundUsingBlock:block];
}

- (void)nx_removeViewControllersUntilClass:(Class)aClass
               withNavigationStackPosition:(NXNavigationStackPosition)position
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block {
    BOOL isReverse = (position == NXNavigationStackPositionFirst);
    NSArray<__kindof UIViewController *> *viewControllers = [self nx_rebuildStackWithViewControllerClass:aClass isReverse:isReverse block:block];
    [self setViewControllers:viewControllers animated:YES];
}

@end
