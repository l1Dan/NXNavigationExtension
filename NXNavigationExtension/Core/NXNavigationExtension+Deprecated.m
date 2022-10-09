//
// NXNavigationExtension+Deprecated.m
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

#import "NXNavigationExtension+Deprecated.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"


@implementation NXNavigationControllerPreferences


@end


@implementation NXViewControllerPreferences (NXNavigationExtensionDeprecated)

- (BOOL)contentViewWithoutNavigationBar {
    return self.systemNavigationBarUserInteractionDisabled;
}

- (void)setContentViewWithoutNavigationBar:(BOOL)contentViewWithoutNavigationBar {
    self.systemNavigationBarUserInteractionDisabled = contentViewWithoutNavigationBar;
}

@end


@implementation UINavigationController (NXNavigationExtensionDeprecated)

- (BOOL)nx_fullScreenInteractivePopGestureEnabled {
    return NO;
}

- (UIViewController *)nx_popViewControllerAnimated:(BOOL)animated {
    return [self nx_popViewControllerAnimated:animated completion:NULL];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self nx_popToViewController:viewController animated:animated completion:NULL];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerAnimated:(BOOL)animated {
    return [self nx_popToRootViewControllerAnimated:animated completion:NULL];
}

- (UIViewController *)nx_popViewControllerWithPush:(UIViewController *)viewControllerToPush animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popAndPushViewController:viewControllerToPush animated:animated completion:completion];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController withPush:(UIViewController *)viewControllerToPush animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popToViewController:viewController andPushViewController:viewControllerToPush animated:animated completion:completion];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerWithPush:(UIViewController *)viewControllerToPush animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popToRootAndPushViewController:viewControllerToPush animated:animated completion:completion];
}

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block {
    [self nx_removeViewControllersUntilClass:aClass insertsToBelowWhenNotFoundUsingBlock:block];
}

- (void)nx_removeViewControllersUntilClass:(Class)aClass
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block {
    [self nx_setPreviousViewControllerWithClass:aClass insertsInstanceToBelowWhenNotFoundUsingBlock:block];
}

- (void)nx_removeViewControllersUntilClass:(Class)aClass
               withNavigationStackPosition:(NXNavigationStackPosition)position
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block {
    [self nx_setPreviousViewControllerWithClass:aClass insertsInstanceToBelowWhenNotFoundUsingBlock:block];
}

@end


@implementation UIViewController (NXNavigationExtensionDeprecated)

- (BOOL)nx_contentViewWithoutNavigationBar {
    return self.nx_systemNavigationBarUserInteractionDisabled;
}

- (UIColor *)nx_shadowImageTintColor {
    return self.nx_shadowColor;
}

- (UIViewController *)nx_popViewControllerWithPresent:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popAndPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController withPresent:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popToViewController:viewController andPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerWithPresent:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    return [self nx_popToRootAndPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

@end
