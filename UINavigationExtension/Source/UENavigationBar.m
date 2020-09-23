//
//  UENavigationBar.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/22.
//

#import "UENavigationBar.h"
#import "UEConfiguration.h"

@implementation UENavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        
        _containerView = [[UIView alloc] init];
        
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _visualEffectView.hidden = YES;
        _visualEffectView.contentView.backgroundColor = [[UEConfiguration defaultConfiguration].backgorundColor colorWithAlphaComponent:0.46];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.visualEffectView];
        [self addSubview:self.shadowImageView];
        [self addSubview:self.containerView];
        
        _backgroundImageView.image = [UEConfiguration defaultConfiguration].backgorundImage;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.visualEffectView.frame = self.bounds;
    self.backgroundImageView.frame = self.bounds;
    
    CGFloat safeAreaTop = 20.0;
    if (@available(iOS 11.0, *)) {
        safeAreaTop = UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    }
    
    CGSize size = self.bounds.size;
    self.containerView.frame = CGRectMake(0, safeAreaTop, size.width, size.height - safeAreaTop);
    
    CGFloat lineHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, size.height - lineHeight, size.width, lineHeight);
}

- (void)enableBlurEffect:(BOOL)enabled {
    if (enabled) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundImageView.hidden = YES;
        self.visualEffectView.hidden = NO;
    }
}

- (void)addContainerSubview:(UIView *)view {
    [self.containerView addSubview:view];
}

@end
