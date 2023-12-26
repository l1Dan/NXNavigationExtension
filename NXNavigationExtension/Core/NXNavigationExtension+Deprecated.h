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

#else

#endif /* __has_include */

NS_ASSUME_NONNULL_BEGIN

API_DEPRECATED_WITH_REPLACEMENT("NXNavigationTransitionState", ios(2.0, 9.0))
typedef NS_ENUM(NSUInteger, NXNavigationAction) {
    NXNavigationActionUnspecified,

    NXNavigationActionWillPush,
    NXNavigationActionDidPush,
    NXNavigationActionPushCancelled,
    NXNavigationActionPushCompleted,

    NXNavigationActionWillPop,
    NXNavigationActionDidPop,
    NXNavigationActionPopCancelled,
    NXNavigationActionPopCompleted,

    NXNavigationActionWillSet,
    NXNavigationActionDidSet,
    NXNavigationActionSetCancelled,
    NXNavigationActionSetCompleted,
};

API_DEPRECATED_WITH_REPLACEMENT("NXNavigationBackAction", ios(2.0, 11.0))
typedef NS_ENUM(NSUInteger, NXNavigationInteractiveType) {
    NXNavigationInteractiveTypeCallNXPopMethod,
    NXNavigationInteractiveTypeBackButtonAction,
    NXNavigationInteractiveTypeBackButtonMenuAction,
    NXNavigationInteractiveTypePopGestureRecognizer,
};

API_DEPRECATED_WITH_REPLACEMENT("NXNavigationTransitionDelegate", ios(2.0, 11.0))
@protocol NXNavigationControllerDelegate <NSObject>

@optional

- (nullable __kindof UIViewController *)nx_navigationController:(__kindof UINavigationController *)navigationController
                                     preparePopToViewController:(__kindof UIViewController *)toViewController
                                             fromViewController:(__kindof UIViewController *)fromViewController API_DEPRECATED("Unavailable.", ios(2.0, 2.0));

- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController
          willPopViewController:(__kindof UIViewController *)viewController
                interactiveType:(NXNavigationInteractiveType)interactiveType API_DEPRECATED_WITH_REPLACEMENT("nx_navigationController:transitionViewController:navigationAction", ios(2.0, 11.0));

- (void)nx_navigationController:(__kindof UINavigationController *)navigationController
          processViewController:(__kindof UIViewController *)viewController
               navigationAction:(NXNavigationAction)navigationAction API_DEPRECATED_WITH_REPLACEMENT("nx_navigationController:transitionViewController:navigationBackAction", ios(2.0, 11.0));

@end

@interface UINavigationController (NXNavigationExtensionDeprecated)

- (void)nx_setPreviousViewControllerWithClass:(Class)aClass
 insertsInstanceToBelowWhenNotFoundUsingBlock:(__kindof UIViewController *_Nullable (^)(void))block API_DEPRECATED("No longer supported.", ios(2.0, 2.0));

@end

NS_ASSUME_NONNULL_END
