//
//  DrawAnimationTransitionDelegate.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/11.
//

#import "DrawAnimationTransitionDelegate.h"
#import "DrawerAnimationController.h"

#import "BaseNavigationController.h"
#import "DrawerViewController.h"

@interface DrawAnimationTransitionDelegate () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) DrawerAnimationController *animationController;
@property (nonatomic, weak) UIViewController *viewController;

@end

@implementation DrawAnimationTransitionDelegate

- (instancetype)init {
    if (self = [super init]) {
        _animationController = [[DrawerAnimationController alloc] init];
    }
    return self;
}

#pragma mark - Private

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.reverse = YES;
    return self.animationController;
}

#pragma mark - Public

- (void)setupDrawerWithViewController:(UIViewController *)viewController inView:(UIView *)view {
    _viewController = viewController;
}

- (void)openDrawer {
    FeatureNavigationController *navigationController = [[FeatureNavigationController alloc] initWithRootViewController:[[DrawerViewController alloc] init]];
    navigationController.transitioningDelegate = self;
    navigationController.modalPresentationStyle = UIModalPresentationCustom;
    navigationController.modalPresentationCapturesStatusBarAppearance = YES; // 隐藏导航栏
    [self.viewController presentViewController:navigationController animated:YES completion:NULL];
}

- (void)closeDrawer {
    
}

@end
