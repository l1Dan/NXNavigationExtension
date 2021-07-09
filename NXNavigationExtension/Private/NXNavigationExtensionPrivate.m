//
// NXNavigationExtensionPrivate.m
//
// Copyright (c) 2021 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import "NXNavigationMenuBackControl.h"
#import "NXNavigationExtensionPrivate.h"
#import "NXNavigationExtensionMacro.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"

@implementation NXEdgeGestureRecognizerDelegate

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

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willPopViewControllerUsingInteractingGesture:)]) {
        return [(id<NXNavigationExtensionInteractable>)topViewController navigationController:self.navigationController willPopViewControllerUsingInteractingGesture:YES];
    }

    return YES;
}

@end


@implementation NXFullscreenPopGestureRecognizerDelegate

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
    if (!topViewController.nx_enableFullScreenInteractivePopGesture) {
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

    if (topViewController && [topViewController respondsToSelector:@selector(navigationController:willPopViewControllerUsingInteractingGesture:)]) {
        return [(id<NXNavigationExtensionInteractable>)topViewController navigationController:self.navigationController willPopViewControllerUsingInteractingGesture:YES];
    }

    return YES;
}

@end

@implementation UIScrollView (NXNavigationExtensionPrivate)

- (NXNavigationBar *)nx_navigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_navigationBar:(NXNavigationBar *)nx_navigationBar {
    objc_setAssociatedObject(self, @selector(nx_navigationBar), nx_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionSwizzleMethod([UIScrollView class], @selector(removeFromSuperview), @selector(nx_removeFromSuperview));
        NXNavigationExtensionSwizzleMethod([UIScrollView class], @selector(didMoveToSuperview), @selector(nx_didMoveToSuperview));
    });
}

- (void)nx_removeFromSuperview {
    [self nx_removeFromSuperview];
    if (self.nx_navigationBar) {
        [self.nx_navigationBar removeFromSuperview];
    }
}

- (void)nx_didMoveToSuperview {
    [self nx_didMoveToSuperview];
    if (self.nx_navigationBar) {
        [self.superview addSubview:self.nx_navigationBar];
        [self.superview bringSubviewToFront:self.nx_navigationBar];
        [self.superview bringSubviewToFront:self.nx_navigationBar.containerView];
    }
}

@end

@implementation UIView (NXNavigationExtensionPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NXNavigationExtensionSwizzleMethod([UIView class], @selector(layoutSubviews), @selector(nx_layoutSubviews));
        NXNavigationExtensionSwizzleMethod([UIView class], @selector(setUserInteractionEnabled:), @selector(nx_setUserInteractionEnabled:));
    });
}

- (void)nx_layoutSubviews {
    if ([self isKindOfClass:[UINavigationBar class]]) {
        UINavigationBarDidUpdateFrameHandler didUpdateFrameHandler = self.nx_didUpdateFrameHandler;
        if (didUpdateFrameHandler) {
            didUpdateFrameHandler(self.frame);
        }
    } else if ([self isKindOfClass:NSClassFromString(@"_UIContextMenuContainerView")]) {
        UIWindow *window = NXNavigationExtensionGetKeyWindow();
        if (window.nx_showingBackButtonMenu) {
            [self nx_findContextMenuActionsListView:self];
        }
    }
    
    [self nx_layoutSubviews];
}

- (void)nx_findContextMenuActionsListView:(UIView *)subview {
    if ([subview isKindOfClass:NSClassFromString(@"_UIContextMenuActionsListView")]) {
        // {{8, 95}, {250, 43.666666666666664}} => {{8.0000000000000018, 47}, {250, 43.666666666666664}}
        CGRect rect = subview.frame;
        CGFloat offset = rect.origin.y - 47; // BackButton menu, Actions:(Push/Modal->Push)
        rect.origin.y = offset > 0 ? offset : 8;
        subview.frame = rect;
        return;
    }

    for (UIView *v in subview.subviews) {
        [self nx_findContextMenuActionsListView:v];
    }
}

#pragma mark - Getter & Setter

- (UINavigationBarDidUpdateFrameHandler)nx_didUpdateFrameHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_didUpdateFrameHandler:(UINavigationBarDidUpdateFrameHandler)nx_didUpdateFrameHandler {
    objc_setAssociatedObject(self, @selector(nx_didUpdateFrameHandler), nx_didUpdateFrameHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)nx_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if (self.nx_disableUserInteraction) {
        [self nx_setUserInteractionEnabled:NO];
        return;
    }
    [self nx_setUserInteractionEnabled:userInteractionEnabled];
}

- (BOOL)nx_disableUserInteraction {
    NSNumber *disableUserInteraction = objc_getAssociatedObject(self, _cmd);
    if (disableUserInteraction && [disableUserInteraction isKindOfClass:[NSNumber class]]) {
        return [disableUserInteraction boolValue];
    }
    disableUserInteraction = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, disableUserInteraction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [disableUserInteraction boolValue];
}

- (void)setNx_disableUserInteraction:(BOOL)nx_disableUserInteraction {
    objc_setAssociatedObject(self, @selector(nx_disableUserInteraction), [NSNumber numberWithBool:nx_disableUserInteraction], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)nx_showingBackButtonMenu {
    NSNumber *showingBackButtonMenu = objc_getAssociatedObject(self, _cmd);
    if (showingBackButtonMenu && [showingBackButtonMenu isKindOfClass:[NSNumber class]]) {
        return [showingBackButtonMenu boolValue];
    }
    showingBackButtonMenu = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, _cmd, showingBackButtonMenu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return [showingBackButtonMenu boolValue];
}

- (void)setNx_showingBackButtonMenu:(BOOL)nx_showingBackButtonMenu {
    objc_setAssociatedObject(self, @selector(nx_showingBackButtonMenu), [NSNumber numberWithBool:nx_showingBackButtonMenu], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (NXNavigationExtensionPrivate)

- (void)nx_configureNavigationBarItemWithViewConstrollers:(NSArray<__kindof UIViewController *> *)viewControllers {
    if (!viewControllers && !viewControllers.count) {
        return;
    }
    
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray arrayWithArray:viewControllers];
    if (viewControllers.lastObject == self) {
        [controllers removeLastObject]; // 返回按钮菜单不需要显示自己
    }
        
    UIBarButtonItem *backButtonItem = self.navigationItem.leftBarButtonItem;
    if (backButtonItem) {
        if (backButtonItem.customView && [backButtonItem.customView isKindOfClass:[NXNavigationMenuBackControl class]]) {
            NXNavigationMenuBackControl *menuBackControl = (NXNavigationMenuBackControl *)backButtonItem.customView;
            // Updated menu
            if ([menuBackControl isKindOfClass:[NXNavigationMenuBackControl class]]) {
                [menuBackControl setViewControllers:controllers];
                menuBackControl.tintColor = self.nx_hidesNavigationBar ? [UIColor clearColor] : self.nx_barTintColor;
                // 检查 menu 是否可用
                if (@available(iOS 14.0, *)) {
                    menuBackControl.contextMenuInteractionEnabled = self.nx_backButtonMenuEnabled;
                }
            }
        }
    } else {
        // 如果 leftBarButtonItem(s) 为空则添加 backButtonItem
        UIImage *backImage = self.nx_backImage;
        if (!backImage) {
            backImage = [NXNavigationBarAppearance standardAppearance].backImage;
        }
        
        NXNavigationMenuBackControl *menuBackControl = [[NXNavigationMenuBackControl alloc] initWithImage:backImage];
        UIView *customView = self.nx_backButtonCustomView;
        if (customView) {
            menuBackControl = [[NXNavigationMenuBackControl alloc] initWithCustomView:customView];
        }
        
        CGFloat navigationBarHeight = CGRectGetHeight(controllers.lastObject.navigationController.navigationBar.frame);
        menuBackControl.frame = CGRectMake(0, 0, 36, navigationBarHeight);
        menuBackControl.menuTintColor = self.nx_hidesNavigationBar ? [UIColor clearColor] : self.nx_barTintColor;
        [menuBackControl setViewControllers:controllers];
        [menuBackControl addTarget:self action:@selector(nx_triggerSystemPopViewController) forControlEvents:UIControlEventTouchUpInside];
        // 检查 menu 是否可用
        if (@available(iOS 14.0, *)) {
            menuBackControl.contextMenuInteractionEnabled = self.nx_backButtonMenuEnabled;
        }
        
        backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBackControl];
    }
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

/// 保证 self.navigationController 不为 nil，不要直接调研 navigationController 方法
- (void)nx_triggerSystemPopViewController {
    [self.navigationController nx_popViewControllerAnimated:YES];
}

@end

@implementation UINavigationController (NXNavigationExtensionPrivate)

- (NXEdgeGestureRecognizerDelegate *)nx_gestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNx_gestureDelegate:(NXEdgeGestureRecognizerDelegate *)nx_gestureDelegate {
    objc_setAssociatedObject(self, @selector(nx_gestureDelegate), nx_gestureDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NXFullscreenPopGestureRecognizerDelegate *)nx_fullscreenPopGestureDelegate {
    NXFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (delegate && [delegate isKindOfClass:[NXFullscreenPopGestureRecognizerDelegate class]]) {
        return delegate;
    }
    delegate = [[NXFullscreenPopGestureRecognizerDelegate alloc] initWithNavigationController:self];
    objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return delegate;
}

- (NXNavigationBarAppearance *)nx_appearance {
    return [NXNavigationBar standardAppearanceForNavigationControllerClass:[self class]];
}

- (BOOL)nx_useNavigationBar {
    return self.nx_appearance != nil;
}

- (void)nx_configureNavigationBar {
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTranslucent:YES];

    self.nx_gestureDelegate = [[NXEdgeGestureRecognizerDelegate alloc] initWithNavigationController:self];
    self.interactivePopGestureRecognizer.delegate = self.nx_gestureDelegate;
}

@end
