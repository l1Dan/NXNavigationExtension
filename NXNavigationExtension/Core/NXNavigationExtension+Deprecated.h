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

#import <NXNavigationExtension/NXNavigationBar.h>

NS_ASSUME_NONNULL_BEGIN


API_DEPRECATED("Use NXNavigationInteractable protocol.", ios(2.0, 2.0)) @protocol NXNavigationExtensionInteractable <NSObject>

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractingGesture:(BOOL)interactingGesture API_DEPRECATED("Use nx_navigationController:willPopViewController:interactiveType: instead.", ios(2.0, 2.0));

@end


@interface NXNavigationBar (NXNavigationExtensionDeprecated)

@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets API_DEPRECATED("Use contentViewEdgeInsets instead.", ios(2.0, 2.0));

@property (nonatomic, strong, readonly) UIView *containerView API_DEPRECATED("Use contentView instead.", ios(2.0, 2.0));

@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView API_DEPRECATED("Use backgroundEffectView instead.", ios(2.0, 2.0));

- (void)enableBlurEffect:(BOOL)enabled API_DEPRECATED("Use UIViewController nx_useBlurNavigationBar instead.", ios(2.0, 2.0));

- (void)addContainerViewSubview:(UIView *)subview API_DEPRECATED("Use containerView addSubview: instead.", ios(2.0, 2.0));

- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets API_DEPRECATED("Use contentViewEdgeInsets instead.", ios(2.0, 2.0));

+ (nullable NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use appearanceFromRegisterNavigationControllerClass: instead.", ios(2.0, 2.0));

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use registerNavigationControllerClass:forAppearance: instead.", ios(2.0, 2.0));

+ (nullable NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass API_DEPRECATED("Use appearanceInNavigationController: instead.", ios(2.0, 2.0));

@end


@interface UINavigationController (NXNavigationExtensionDeprecated)

- (void)nx_triggerSystemBackButtonHandler API_DEPRECATED("Use nx_popViewControllerAnimated: instead.", ios(2.0, 2.0));

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerBlock:(__kindof UIViewController * _Nullable(^__nullable)(void))block API_DEPRECATED("Use nx_redirectViewControllerClass:initializeStandbyViewControllerUsingBlock: instead.", ios(2.0, 2.0));

@end


@interface UIViewController (NXNavigationExtensionDeprecated)

@property (nonatomic, assign, readonly) BOOL nx_useSystemBlurNavigationBar API_DEPRECATED("Use nx_useBlurNavigationBar & nx_navigationBarBackgroundColor instead.", ios(2.0, 2.0));

@property (nonatomic, assign, readonly) BOOL nx_enableFullScreenInteractivePopGesture API_DEPRECATED("Use nx_enableFullscreenInteractivePopGesture instead.", ios(2.0, 2.0));

@property (nonatomic, assign, readonly) BOOL nx_hidesNavigationBar API_DEPRECATED("Use nx_translucentNavigationBar instead.", ios(2.0, 2.0));

@property (nonatomic, assign, readonly) BOOL nx_containerViewWithoutNavigtionBar API_DEPRECATED("Use nx_contentViewWithoutNavigtionBar instead.", ios(2.0, 2.0));

@end


NS_ASSUME_NONNULL_END