//
// UNXNavigatorPrivate.m
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

#import "UNXNavigatorPrivate.h"
#import "UNXNavigatorMacro.h"
#import "UINavigationController+UNXNavigator.h"
#import "UIViewController+UNXNavigator.h"

@implementation UEEdgeGestureRecognizerDelegate

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
    if (topViewController && topViewController.unx_disableInteractivePopGesture) {
        return NO;
    }

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willPopViewControllerUsingInteractingGesture:)]) {
        return [(id<UNXNavigatorInteractable>)topViewController navigationController:self.navigationController willPopViewControllerUsingInteractingGesture:YES];
    }

    return YES;
}

@end


@implementation UEFullscreenPopGestureRecognizerDelegate

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
    if (!topViewController.unx_enableFullScreenInteractivePopGesture) {
        return NO;
    }

    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.unx_interactivePopMaxAllowedDistanceToLeftEdge;
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

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willPopViewControllerUsingInteractingGesture:)]) {
        return [(id<UNXNavigatorInteractable>)topViewController navigationController:self.navigationController willPopViewControllerUsingInteractingGesture:YES];
    }

    return YES;
}

@end

@implementation UIScrollView (UNXNavigatorPrivate)

- (UNXNavigationBar *)unx_navigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnx_navigationBar:(UNXNavigationBar *)unx_navigationBar {
    objc_setAssociatedObject(self, @selector(unx_navigationBar), unx_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UNXNavigatorSwizzleMethod([UIScrollView class], @selector(removeFromSuperview), @selector(unx_removeFromSuperview));
        UNXNavigatorSwizzleMethod([UIScrollView class], @selector(didMoveToSuperview), @selector(unx_didMoveToSuperview));
    });
}

- (void)unx_removeFromSuperview {
    [self unx_removeFromSuperview];
    if (self.unx_navigationBar) {
        [self.unx_navigationBar removeFromSuperview];
    }
}

- (void)unx_didMoveToSuperview {
    [self unx_didMoveToSuperview];
    if (self.unx_navigationBar) {
        [self.superview addSubview:self.unx_navigationBar];
        [self.superview bringSubviewToFront:self.unx_navigationBar];
        [self.superview bringSubviewToFront:self.unx_navigationBar.containerView];
    }
}

@end

@implementation UINavigationBar (UNXNavigatorPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UNXNavigatorSwizzleMethod([UINavigationBar class], @selector(layoutSubviews), @selector(unx_layoutSubviews));
        UNXNavigatorSwizzleMethod([UINavigationBar class], @selector(setUserInteractionEnabled:), @selector(unx_setUserInteractionEnabled:));
    });
}

- (void)unx_layoutSubviews {
    UINavigationBarDidUpdateFrameHandler didUpdateFrameHandler = self.unx_didUpdateFrameHandler;
    if (didUpdateFrameHandler) {
        didUpdateFrameHandler(self.frame);
    }
    [self unx_layoutSubviews];
}

#pragma mark - Getter & Setter

- (UINavigationBarDidUpdateFrameHandler)unx_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnx_didUpdateFrameHandler:(UINavigationBarDidUpdateFrameHandler)unx_didUpdateFrameHandler {
    objc_setAssociatedObject(self, @selector(unx_didUpdateFrameHandler), unx_didUpdateFrameHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)unx_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if (self.unx_disableUserInteraction) {
        [self unx_setUserInteractionEnabled:NO];
        return;
    }
    [self unx_setUserInteractionEnabled:userInteractionEnabled];
}

- (BOOL)unx_disableUserInteraction {
    NSNumber *disableUserInteraction = objc_getAssociatedObject(self, _cmd);
    if (disableUserInteraction && [disableUserInteraction isKindOfClass:[NSNumber class]]) {
        return [disableUserInteraction boolValue];
    }
    disableUserInteraction = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, disableUserInteraction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [disableUserInteraction boolValue];
}

- (void)setUnx_disableUserInteraction:(BOOL)unx_disableUserInteraction {
    objc_setAssociatedObject(self, @selector(unx_disableUserInteraction), [NSNumber numberWithBool:unx_disableUserInteraction], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (UNXNavigatorPrivate)

- (void)unx_configureNavigationBarItem {
    UIBarButtonItem *backButtonItem = self.navigationItem.leftBarButtonItem;
    UIView *customView = self.unx_backButtonCustomView;
    if (customView) {
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unx_triggerSystemPopViewController)];
        customView.userInteractionEnabled = YES;
        [customView addGestureRecognizer:tap];
    } else {
        // 如果 leftBarButtonItem(s) 为空则添加 backButtonItem
        if (!backButtonItem) {
            UIImage *backImage = self.unx_backImage;
            if (!backImage) {
                backImage = [UNXNavigationBarAppearance standardAppearance].backImage;
            }
            backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(unx_triggerSystemPopViewController)];            
        }
    }
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

/// 保证 self.navigationController 不为 nil
- (void)unx_triggerSystemPopViewController {
    [self.navigationController unx_triggerSystemBackButtonHandler];
}

@end

@implementation UINavigationController (UNXNavigatorPrivate)

- (UEEdgeGestureRecognizerDelegate *)unx_gestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnx_gestureDelegate:(UEEdgeGestureRecognizerDelegate *)unx_gestureDelegate {
    objc_setAssociatedObject(self, @selector(unx_gestureDelegate), unx_gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UEFullscreenPopGestureRecognizerDelegate *)unx_fullscreenPopGestureDelegate {
    UEFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate && [delegate isKindOfClass:[UEFullscreenPopGestureRecognizerDelegate class]]) {
        return delegate;
    }
    delegate = [[UEFullscreenPopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return delegate;
}

- (UNXNavigationBarAppearance *)unx_appearance {
    return [UNXNavigationBar standardAppearanceInNavigationControllerClass:[self class]];
}

- (BOOL)unx_useNavigationBar {
    return self.unx_appearance != nil;
}

- (void)unx_configureNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];

    self.unx_gestureDelegate = [[UEEdgeGestureRecognizerDelegate alloc] initWithNavigationController:self];
    self.interactivePopGestureRecognizer.delegate = self.unx_gestureDelegate;
}

@end
