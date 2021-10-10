//
//  DrawerAnimationController.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/10.
//

#import "DrawerAnimationController.h"
#import "UIColor+RandomColor.h"

@interface DrawerAnimationController ()

@property (nonatomic, strong) UIVisualEffectView *backgorundColorView;

@end

@implementation DrawerAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.reverse) {
        [self executeReverseAnimation:transitionContext fromVC:fromVC toVC:toVC];
    } else {
        [self executeForwardsAnimation:transitionContext fromVC:fromVC toVC:toVC];
    }
}

-(void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    self.backgorundColorView.frame = containerView.bounds;
    self.backgorundColorView.alpha = 0.0;
    [containerView insertSubview:self.backgorundColorView belowSubview:toVC.view];
    
    CGRect toViewFinalFrame =  [transitionContext finalFrameForViewController:toVC];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    toVC.view.frame = CGRectOffset(toViewFinalFrame, -screenBounds.size.width, 0);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        toVC.view.frame = UIEdgeInsetsInsetRect(screenBounds, UIEdgeInsetsMake(0, 0, 0, screenBounds.size.width * 0.15));
        toVC.view.layer.cornerRadius = 10;
        toVC.view.clipsToBounds = YES;
        
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        fromVC.view.layer.cornerRadius = 10;
        fromVC.view.clipsToBounds = YES;
        
        self.backgorundColorView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

-(void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    // fix: white/black screen
    if (fromVC.modalPresentationStyle == UIModalPresentationFullScreen) {
        UIView *containerView = [transitionContext containerView];
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
    CGRect fromViewFinalFrame =  [transitionContext finalFrameForViewController:fromVC];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        toVC.view.layer.cornerRadius = 0;
        toVC.view.clipsToBounds = NO;
        toVC.view.transform = CGAffineTransformIdentity;
        
        fromVC.view.frame = CGRectOffset(fromViewFinalFrame, -fromViewFinalFrame.size.width, 0);
        
        self.backgorundColorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.reverse = NO;
        if ([transitionContext transitionWasCancelled]) {
            toVC.view.layer.cornerRadius = 0;
            toVC.view.clipsToBounds = NO;
            toVC.view.transform = CGAffineTransformIdentity;
            
            self.backgorundColorView.alpha = 1.0;
        } else {
            [self.backgorundColorView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - Getter

- (UIVisualEffectView *)backgorundColorView {
    if (!_backgorundColorView) {
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _backgorundColorView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backgorundColorView.alpha = 0.0;
    }
    return _backgorundColorView;
}

@end
