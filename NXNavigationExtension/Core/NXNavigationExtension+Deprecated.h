//
//  NXNavigationExtension+Deprecated.h
//  NXNavigationExtension
//
//  Created by lidan on 2021/9/28.
//

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

+ (nullable NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use appearanceInNavigationController: instead.", ios(2.0, 2.0));

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass API_DEPRECATED("Use setAppearanceForNavigationControllerUsingBlock: instead.", ios(2.0, 2.0));

+ (nullable NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass API_DEPRECATED("Use appearanceInNavigationController: instead.", ios(2.0, 2.0));

+ (void)registerNavigationControllerClass:(Class)aClass forAppearance:(nullable NXNavigationBarAppearance *)appearance API_DEPRECATED("Use setAppearanceForNavigationControllerUsingBlock: instead.", ios(2.0, 2.0));

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
