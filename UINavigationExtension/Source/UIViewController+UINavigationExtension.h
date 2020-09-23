//
//  UIViewController+UINavigationExtension.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UENavigationBar;
@interface UIViewController (UINavigationExtension)

@property (nonatomic, strong, readonly) UENavigationBar *ue_navigationBar;
@property (nonatomic, strong, readonly, nullable) UIColor *ue_navigationBarBackgroundColor;
@property (nonatomic, strong, readonly, nullable) UIImage *ue_navigationBarBackgroundImage;

@property (nonatomic, strong, readonly, nullable) UIColor *ue_barBarTintColor;
@property (nonatomic, strong, readonly, nullable) UIColor *ue_barTintColor;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSAttributedStringKey, id> *ue_titleTextAttributes;

@property (nonatomic, strong, readonly, nullable) UIImage *ue_shadowImage;
@property (nonatomic, strong, readonly, nullable) UIColor *ue_shadowImageTintColor;

@property (nonatomic, strong, readonly, nullable) UIImage *ue_backImage;
@property (nonatomic, strong, readonly, nullable) UIView *ue_backButtonCustomView;

@property (nonatomic, assign, readonly, getter=isUeUseSystemBlurNavigationBar) BOOL ue_useSystemBlurNavigationBar;
@property (nonatomic, assign, readonly, getter=isUeDisableInteractivePopGesture) BOOL ue_disableInteractivePopGesture;
@property (nonatomic, assign, readonly, getter=isUeEnableFullScreenInteractivePopGesture) BOOL ue_enableFullScreenInteractivePopGesture;
@property (nonatomic, assign, readonly, getter=isUeAutomaticallyHideNavigationBarInChildViewController) BOOL ue_automaticallyHideNavigationBarInChildViewController;
@property (nonatomic, assign, readonly, getter=isUeHidesNavigationBar) BOOL ue_hidesNavigationBar;

@property (nonatomic, assign) CGFloat ue_interactivePopMaxAllowedDistanceToLeftEdge;

- (void)ue_ue_triggerSystemBackButtonHandler;

- (void)ue_triggerSystemBackButtonHandle;

@end

NS_ASSUME_NONNULL_END
