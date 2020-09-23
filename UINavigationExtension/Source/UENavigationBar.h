//
//  UENavigationBar.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UENavigationBar : UIView

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

- (void)enableBlurEffect:(BOOL)enabled;

- (void)addContainerSubview:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
