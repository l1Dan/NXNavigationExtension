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

/// UENavigationBar 底部阴影
@property (nonatomic, strong, readonly) UIImageView *shadowImageView;

/// UENavigationBar 背景
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// 模糊背景
@property (nonatomic, strong, readonly) UIVisualEffectView *visualEffectView;

/// 设置 UENavigationBar 模糊背景，背景穿透效果
/// @param enabled 是否使用模糊背景；默认 NO
- (void)enableBlurEffect:(BOOL)enabled;

- (void)addContainerSubview:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
