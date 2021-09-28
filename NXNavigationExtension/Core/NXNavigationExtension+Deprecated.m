//
//  NXNavigationExtension+Deprecated.m
//  NXNavigationExtension
//
//  Created by lidan on 2021/9/28.
//

#import "NXNavigationExtension+Deprecated.h"
#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"

@interface NXNavigationBar ()

@property (nonatomic, assign) BOOL blurEffectEnabled;

@end


@implementation NXNavigationBar (NXNavigationExtensionDeprecated)

+ (NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *)appearanceInfo {
    static NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *appearanceInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearanceInfo = [NSMutableDictionary dictionary];
    });
    return appearanceInfo;
}

- (UIView *)containerView {
    return self.contentView;
}

- (UIVisualEffectView *)visualEffectView {
    return self.backgroundEffectView;
}

- (void)addContainerViewSubview:(UIView *)subview {
    if (subview != self.containerView) {
        [self.containerView addSubview:subview];
    }
}

- (UIEdgeInsets)containerViewEdgeInsets {
    return self.contentViewEdgeInsets;
}

- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets {
    self.contentViewEdgeInsets = edgeInsets;
}

+ (NXNavigationBarAppearance *)standardAppearanceForNavigationControllerClass:(Class)aClass {
    return [self appearanceFromRegisterNavigationControllerClass:aClass];
}

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass {
    [self registerNavigationControllerClass:aClass forAppearance:[NXNavigationBarAppearance standardAppearance]];
}

+ (NXNavigationBarAppearance *)appearanceFromRegisterNavigationControllerClass:(Class)aClass {
    if (aClass) {
        return [NXNavigationBar appearanceInfo][NSStringFromClass(aClass)];
    }
    return nil;
}

+ (void)registerNavigationControllerClass:(Class)aClass forAppearance:(NXNavigationBarAppearance *)appearance {
    NSAssert(aClass != nil, @"参数不能为空！");
    if (!aClass) return;
    
    [NXNavigationBar appearanceInfo][NSStringFromClass(aClass)] = appearance ?: [NXNavigationBarAppearance standardAppearance];
    [NXNavigationBar setAppearanceForNavigationControllerUsingBlock:^NXNavigationBarAppearance * _Nullable(__kindof UINavigationController * _Nonnull navigationController) {
        return [self appearanceFromRegisterNavigationControllerClass:[navigationController class]];
    }];
}

- (void)enableBlurEffect:(BOOL)enabled {
    self.blurEffectEnabled = enabled;
}

@end


@implementation UINavigationController (NXNavigationExtensionDeprecated)

- (void)nx_triggerSystemBackButtonHandler {
    [self nx_popViewControllerAnimated:YES];
}

- (void)nx_redirectViewControllerClass:(Class)aClass initializeStandbyViewControllerBlock:(__kindof UIViewController * _Nullable (^)(void))block {
    [self nx_redirectViewControllerClass:aClass initializeStandbyViewControllerUsingBlock:block];
}

@end


@implementation UIViewController (NXNavigationExtensionDeprecated)

- (BOOL)nx_useSystemBlurNavigationBar {
    return [self nx_useBlurNavigationBar];
}

- (BOOL)nx_enableFullScreenInteractivePopGesture {
    return [self nx_enableFullscreenInteractivePopGesture];
}

- (BOOL)nx_hidesNavigationBar {
    return [self nx_translucentNavigationBar];
}

- (BOOL)nx_containerViewWithoutNavigtionBar {
    return [self nx_contentViewWithoutNavigtionBar];
}

@end
