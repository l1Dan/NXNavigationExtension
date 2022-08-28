//
// NXNavigationExtension+Deprecated.h
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

#import <UIKit/UIKit.h>

#if __has_include(<NXNavigationExtension/NXNavigationExtension.h>)

#import <NXNavigationExtension/UINavigationController+NXNavigationExtension.h>

#else

#import "UINavigationController+NXNavigationExtension.h"

#endif /* __has_include */

NS_ASSUME_NONNULL_BEGIN

API_DEPRECATED("Use NXNavigationControllerDelegate.", ios(2.0, 2.0))
@protocol NXNavigationInteractable <NXNavigationControllerDelegate>

@end


API_DEPRECATED("", ios(2.0, 2.0))
typedef NS_ENUM(NSUInteger, NXNavigationStackPosition) {
    NXNavigationStackPositionLast = 0, // Default
    NXNavigationStackPositionFirst = 1,
};


@interface NXNavigationControllerPreferences (NXNavigationExtensionDeprecated)

@property (nonatomic, assign) BOOL fullScreenInteractivePopGestureEnabled API_DEPRECATED("Use NXViewControllerPreferences enableFullScreenInteractivePopGesture instead.", ios(2.0, 2.0));

@end


@interface NXViewControllerPreferences (NXNavigationExtensionDeprecated)

@property (nonatomic, assign) BOOL contentViewWithoutNavigationBar API_DEPRECATED("Use systemNavigationBarUserInteractionDisabled instead.", ios(2.0, 2.0));

@end


@interface UINavigationController (NXNavigationExtensionDeprecated)

@property (nonatomic, assign, readonly) BOOL nx_fullScreenInteractivePopGestureEnabled API_DEPRECATED("Use UIViewController nx_enableFullScreenInteractivePopGesture instead.", ios(2.0, 2.0));

- (nullable UIViewController *)nx_popViewControllerAnimated:(BOOL)animated OBJC_SWIFT_UNAVAILABLE("") API_DEPRECATED("Use UINavigationController nx_popViewController(animated:completion:) instead.", ios(2.0, 2.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                                 animated:(BOOL)animated OBJC_SWIFT_UNAVAILABLE("") API_DEPRECATED("Use UINavigationController nx_popToViewController(_:animated:completion:)) instead.", ios(2.0, 2.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerAnimated:(BOOL)animated OBJC_SWIFT_UNAVAILABLE("") API_DEPRECATED("Use UINavigationController nx_popToRootViewController(animated:completion:) method", ios(2.0, 2.0));

- (nullable UIViewController *)nx_popViewControllerWithPush:(UIViewController *)viewControllerToPush
                                                   animated:(BOOL)animated
                                                 completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popViewControllerWithPush(_:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popAndPushViewController:animated:completion:", ios(2.0, 9.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                                 withPush:(UIViewController *)viewControllerToPush
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:withPush:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popToViewController:andPushViewController:animated:completion:", ios(2.0, 9.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerWithPush:(UIViewController *)viewControllerToPush
                                                                             animated:(BOOL)animated
                                                                           completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToRootViewControllerWithPush(_:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popToRootAndPushViewController:animated:completion:", ios(2.0, 9.0));

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerUsingBlock:(__kindof UIViewController *_Nullable (^__nullable)(void))block API_DEPRECATED("Use UINavigationController nx_setPreviousViewControllerWithClass:insertsInstanceToBelowWhenNotFoundUsingBlock: instead.", ios(2.0, 9.0));

- (void)nx_removeViewControllersUntilClass:(Class)aClass
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block API_DEPRECATED_WITH_REPLACEMENT("nx_setPreviousViewControllerWithClass:insertsInstanceToBelowWhenNotFoundUsingBlock:", ios(2.0, 9.0));

- (void)nx_removeViewControllersUntilClass:(Class)aClass
               withNavigationStackPosition:(NXNavigationStackPosition)position
      insertsToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block API_DEPRECATED("Use UINavigationController nx_setPreviousViewControllerWithClass:insertsInstanceToBelowWhenNotFoundUsingBlock: instead.", ios(2.0, 9.0));

@end


@interface UIViewController (NXNavigationExtensionDeprecated)

@property (nonatomic, assign, readonly) BOOL nx_contentViewWithoutNavigationBar API_DEPRECATED("Use nx_systemNavigationBarUserInteractionDisabled instead.", ios(2.0, 2.0));

- (nullable UIViewController *)nx_popViewControllerWithPresent:(UIViewController *)viewControllerToPresent
                                                      animated:(BOOL)animated
                                                    completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popViewControllerWithPresent(_:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popAndPresentViewController:animated:completion:", ios(2.0, 9.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToViewController:(UIViewController *)viewController
                                                              withPresent:(UIViewController *)viewControllerToPresent
                                                                 animated:(BOOL)animated
                                                               completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToViewController(_:withPresent:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popToViewController:andPresentViewController:animated:completion:", ios(2.0, 9.0));

- (nullable NSArray<__kindof UIViewController *> *)nx_popToRootViewControllerWithPresent:(UIViewController *)viewControllerToPresent
                                                                                animated:(BOOL)animated
                                                                              completion:(void (^__nullable)(void))completion NS_SWIFT_NAME(nx_popToRootViewControllerWithPresent(_:animated:completion:)) API_DEPRECATED_WITH_REPLACEMENT("nx_popToRootAndPresentViewController:animated:completion:", ios(2.0, 9.0));

@end

NS_ASSUME_NONNULL_END
