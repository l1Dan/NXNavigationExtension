//
//  UENavigationBar.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/22.
//

#import "UENavigationBar.h"

static UENavigationBarAppearance *standardUENavigationBarAppearance;

@implementation UENavigationBarAppearance

- (instancetype)init {
    if (self = [super init]) {
        _tintColor = [UIColor systemBlueColor];
        _backgorundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Getter
- (UIImage *)backImage {
    if (!_backImage) {
        NSString *backImageBase64 = @"iVBORw0KGgoAAAANSUhEUgAAABgAAAAqCAYAAACpxZteAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGKADAAQAAAABAAAAKgAAAAA51J5LAAADnklEQVRIDbVXSWhUQRCtzmbUGKIgQXGLBhRFQVEQMduMkwQNqKBCLrkJXvSkqDN/ZCCOBw8ePEhy8SAYISBEggvuERFF0agYFTRIQiS4EEOIuGDKV7N8f//5s/yZsWD6d1dXvVdVv7t/D9H/EIOX0SmeLtAqr/hhrqRJugDMBiB/w7OtMG8Efp5Hv+kO8DbEMEtBsrAgLwQhXgCwPmCtsOGN5F6iEC+iX5HIl9rAJ6iQanLLwOAqlOUegO3g4wD3Ubt6nj1BiKuJURamxbbIxwDuBfgj0WdXIoOX0xTdhv98DVzRFxD66ITqj+vdZxDilQC56wD+iYqxPC3gQuIugyCvpj90C35zxdkURaNA8tBx9drUxTqZZxDktQCXdW4HH0HkdU7gwpFZBgFej7Jch/1scbLIEBVEIn9v0Wnd9BkEeCPAb8LLDv6BSiKRJwUXptQZBHgzwK/AbpYYm6JIQBsorIZNXZJO8gyCXAfwa/Czg79FzWszARdOZ4Jj7MU6l8hnipFFBgBeTyH10aJL2U0skZ+bULgeRF+qeSp6CTov+dVnTZ9moGdgcAvsLzmAPwN4g1tw4f5HYPAOAF+EbppMmKLoCZVFIv9q6lx0oiUyeEus5sWar6KHeMXNdESNa3oXg2gGTEH42MHvUzk15gIuccQJKhyCGqYq+u6gd6WKEig6meDF1Er91EUhLkqYc6GIEoTVeeRy0MFvD75Y3dTJevkcDJOp9H1g8H687NMJxop6qZJ20wH1M2EujUInEOMA78NyPYOePqdwbBTTTuziH2kwteloiayqsOpAufYCfsqqBmkzytUbv7FpcykGepRWQz+3YXgWP/1ypvC5rKAWOqQmrebJ+skJxCPArWjPIXp9JSmSPbKVDquJZMBxfWoCsTJ4F4rVhZ6+kjLc5ekJhCTA29F2I5MSGVrkMY6SJjqqxiw6rZsZgbj4eRtap8NQTlofTlrHwzBzAiExuBHl6kEvcvcXVURSfCvcEQiawR6Uqhe/GVF0sx1AAb3YJ6OmBh33BOId4Fq0l0FSJkNTFMn32mP9pGZHIIgB3oT2KkjKTYJo5x3C9sQvBYk72WaddBhWDzDnA5j8VbJKNQZ9OIWXiDL7DMRbxM/rgHIDmcyJKsx2CO+kJncCwQvxGvzLkduffm8l6swPgZAEeVXs5l0pw4goepr9O4iDxJ/t6hVKUo/hYEzFKF1H/jKIE3VzIb3A8VFEb7BcB/8CPBbkXXfy0P4AAAAASUVORK5CYII=";
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:backImageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (data) {
            return [UIImage imageWithData:data scale:2.0];
        }
        return nil;
    }
    return _backImage;
}

@end

@interface UENavigationBar ()

@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets;

@end

@implementation UENavigationBar

+ (UENavigationBarAppearance *)standardAppearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        standardUENavigationBarAppearance = [[UENavigationBarAppearance alloc] init];
    });
    return standardUENavigationBarAppearance;
}

- (instancetype)init {
    return [[[self class] alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        
        _containerView = [[UIView alloc] init];
        _containerViewEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _visualEffectView.hidden = YES;
        _visualEffectView.contentView.backgroundColor = [[UENavigationBar standardAppearance].backgorundColor colorWithAlphaComponent:0.46];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.visualEffectView];
        [self addSubview:self.shadowImageView];
        [self addSubview:self.containerView];
        
        _backgroundImageView.image = [UENavigationBar standardAppearance].backgorundImage;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateNavigationBarContentFrame];
}

// 及时更新 NavigationBar content frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateNavigationBarContentFrame];
}

#pragma mark - Private
- (void)updateNavigationBarContentFrame {
    self.visualEffectView.frame = self.bounds;
    self.backgroundImageView.frame = self.bounds;
    
    CGFloat safeAreaTop = 20.0;
    if (@available(iOS 11.0, *)) {
        safeAreaTop = UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    }
    
    CGSize size = self.bounds.size;
    CGRect originalFrame = CGRectMake(0, safeAreaTop, size.width, size.height - safeAreaTop);
    self.containerView.frame = UIEdgeInsetsInsetRect(originalFrame, self.containerViewEdgeInsets);

    CGFloat lineHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, size.height - lineHeight, size.width, lineHeight);
}

#pragma mark - Public
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

- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets {
    _containerViewEdgeInsets = edgeInsets;
    [self updateNavigationBarContentFrame];
}

@end
