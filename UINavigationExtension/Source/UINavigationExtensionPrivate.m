//
// UINavigationExtensionPrivate.m
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

#import "UINavigationExtensionPrivate.h"
#import "UINavigationExtensionMacro.h"
#import "UINavigationController+UINavigationExtension.h"
#import "UIViewController+UINavigationExtension.h"

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
    if (topViewController && topViewController.ue_disableInteractivePopGesture) {
        return NO;
    }

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willJumpToViewControllerUsingInteractivePopGesture:)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self.navigationController willJumpToViewControllerUsingInteractivePopGesture:YES];
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
    CGFloat multiplier = isLeftToRight ? 1 : -1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willJumpToViewControllerUsingInteractivePopGesture:)]) {
        return [(id<UINavigationControllerCustomizable>)topViewController navigationController:self.navigationController willJumpToViewControllerUsingInteractivePopGesture:YES];
    }

    return YES;
}

@end

@implementation UIView (UINavigationExtensionPrivate)

- (UENavigationBar *)ue_navigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_navigationBar:(UENavigationBar *)ue_navigationBar {
    objc_setAssociatedObject(self, @selector(ue_navigationBar), ue_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UIView class], @selector(removeFromSuperview), @selector(ue_removeFromSuperview));
        UINavigationExtensionSwizzleMethod([UIView class], @selector(didMoveToSuperview), @selector(ue_didMoveToSuperview));
    });
}

- (void)ue_removeFromSuperview {
    [self ue_removeFromSuperview];
    if (self.ue_navigationBar) {
        [self.ue_navigationBar removeFromSuperview];
    }
}

- (void)ue_didMoveToSuperview {
    [self ue_didMoveToSuperview];
    if (self.ue_navigationBar) {
        [self.superview addSubview:self.ue_navigationBar];
        [self.superview bringSubviewToFront:self.ue_navigationBar];
        [self.superview bringSubviewToFront:self.ue_navigationBar.containerView];
    }
}

@end

@implementation UINavigationBar (UINavigationExtensionPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINavigationExtensionSwizzleMethod([UINavigationBar class], @selector(layoutSubviews), @selector(ue_layoutSubviews));
        UINavigationExtensionSwizzleMethod([UINavigationBar class], @selector(setUserInteractionEnabled:), @selector(ue_setUserInteractionEnabled:));
    });
}

- (void)ue_layoutSubviews {
    UINavigationBarDidUpdateFrameHandler didUpdateFrameHandler = self.ue_didUpdateFrameHandler;
    if (didUpdateFrameHandler) {
        didUpdateFrameHandler(self.frame);
    }
    [self ue_layoutSubviews];
}

#pragma mark - Getter & Setter

- (UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_didUpdateFrameHandler:(UINavigationBarDidUpdateFrameHandler)ue_didUpdateFrameHandler {
    objc_setAssociatedObject(self, @selector(ue_didUpdateFrameHandler), ue_didUpdateFrameHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ue_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if (self.ue_navigationBarUserInteractionDisabled) {
        [self ue_setUserInteractionEnabled:NO];
        return;
    }
    [self ue_setUserInteractionEnabled:userInteractionEnabled];
}

- (BOOL)ue_navigationBarUserInteractionDisabled {
    NSNumber *navigationBarUserInteractionDisabled = objc_getAssociatedObject(self, _cmd);
    if (navigationBarUserInteractionDisabled && [navigationBarUserInteractionDisabled isKindOfClass:[NSNumber class]]) {
        return [navigationBarUserInteractionDisabled boolValue];
    }
    navigationBarUserInteractionDisabled = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, navigationBarUserInteractionDisabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [navigationBarUserInteractionDisabled boolValue];
}

- (void)setUe_navigationBarUserInteractionDisabled:(BOOL)ue_navigationBarUserInteractionDisabled {
    objc_setAssociatedObject(self, @selector(ue_navigationBarUserInteractionDisabled), [NSNumber numberWithBool:ue_navigationBarUserInteractionDisabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (UINavigationExtensionPrivate)

- (void)ue_configureNavigationBarItem {
    UIBarButtonItem *backButtonItem;
    UIView *customView = self.ue_backButtonCustomView;
    if (customView) {
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ue_triggerSystemPopViewController)];
        customView.userInteractionEnabled = YES;
        [customView addGestureRecognizer:tap];
    } else {
        UIImage *backImage = self.ue_backImage;
        if (!backImage) {
            backImage = [UENavigationBarAppearance standardAppearance].backImage;
        }
        backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(ue_triggerSystemPopViewController)];
    }
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

/// 保证 self.navigationController 不为 nil
- (void)ue_triggerSystemPopViewController {
    [self.navigationController ue_triggerSystemBackButtonHandle];
}

@end

@implementation UINavigationController (UINavigationExtensionPrivate)

- (UEEdgeGestureRecognizerDelegate *)ue_gestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUe_gestureDelegate:(UEEdgeGestureRecognizerDelegate *)ue_gestureDelegate {
    objc_setAssociatedObject(self, @selector(ue_gestureDelegate), ue_gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UEFullscreenPopGestureRecognizerDelegate *)ue_fullscreenPopGestureDelegate {
    UEFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate && [delegate isKindOfClass:[UEFullscreenPopGestureRecognizerDelegate class]]) {
        return delegate;
    }
    delegate = [[UEFullscreenPopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return delegate;
}

- (UENavigationBarAppearance *)ue_appearance {
    return [UENavigationBar standardAppearanceInNavigationControllerClass:[self class]];
}

- (BOOL)ue_useNavigationBar {
    return self.ue_appearance != nil;
}

- (void)ue_configureNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];

    self.ue_gestureDelegate = [[UEEdgeGestureRecognizerDelegate alloc] initWithNavigationController:self];
    self.interactivePopGestureRecognizer.delegate = self.ue_gestureDelegate;
}

@end
