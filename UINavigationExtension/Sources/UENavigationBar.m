//
// UENavigationBar.m
//
// Copyright (c) 2020 Leo Lee UINavigationExtension (https://github.com/l1Dan/UINavigationExtension)
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

#import "UENavigationBar.h"

@implementation UENavigationBarAppearance

+ (UENavigationBarAppearance *)standardAppearance {
    static UENavigationBarAppearance *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UENavigationBarAppearance alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _tintColor = [UIColor systemBlueColor];
        if (@available(iOS 13.0, *)) {
            _backgorundColor = [UIColor systemBackgroundColor];
        } else {
            _backgorundColor = [UIColor whiteColor];
        }
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

@implementation UENavigationBar {
    CGRect _originalNavigationBarFrame;
    UIEdgeInsets _containerViewEdgeInsets;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _originalNavigationBarFrame = CGRectZero;
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
        _backgroundImageView.image = [UENavigationBarAppearance standardAppearance].backgorundImage;

        [self addSubview:self.backgroundImageView];
        [self addSubview:self.visualEffectView];
        [self addSubview:self.shadowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateNavigationBarContentFrame];
}

- (void)setFrame:(CGRect)frame {
    _originalNavigationBarFrame = frame;
    
    // 重新设置 NavigationBar frame
    [super setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetMaxY(frame))];
    [self updateNavigationBarContentFrame];
}

#pragma mark - Private

- (void)updateNavigationBarContentFrame {
    CGRect navigationBarFrame = CGRectMake(0, 0, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame));
    self.visualEffectView.frame = navigationBarFrame;
    self.backgroundImageView.frame = navigationBarFrame;

    CGRect containerViewFrame = CGRectMake(0, CGRectGetMinY(_originalNavigationBarFrame), CGRectGetWidth(_originalNavigationBarFrame), CGRectGetHeight(_originalNavigationBarFrame));
    self.containerView.frame = UIEdgeInsetsInsetRect(containerViewFrame, _containerViewEdgeInsets);
    
    CGFloat shadowImageViewHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, CGRectGetMaxY(_originalNavigationBarFrame) - shadowImageViewHeight, CGRectGetWidth(navigationBarFrame), shadowImageViewHeight);

    // 放在所有的 View 前面，防止 containerView 被遮挡
    if (self.superview && self.superview != self.containerView.superview) {
        [self.superview addSubview:self.containerView];
    }
    [self.superview bringSubviewToFront:self.containerView];
}

+ (NSMutableDictionary<NSString *, UENavigationBarAppearance *> *)appearanceInfo {
    static NSMutableDictionary<NSString *, UENavigationBarAppearance *> *appearanceInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appearanceInfo = [NSMutableDictionary dictionary];
    });
    return appearanceInfo;
}

#pragma mark - Public

- (void)enableBlurEffect:(BOOL)enabled {
    if (enabled) {
        self.backgroundColor = [UIColor clearColor];
        self.containerView.backgroundColor = [UIColor clearColor];
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

+ (UENavigationBarAppearance *)standardAppearanceInNavigationControllerClass:(Class)aClass {
    if (aClass) {
        return [UENavigationBar appearanceInfo][NSStringFromClass(aClass)];
    }
    return nil;
}

+ (void)registerStandardAppearanceForNavigationControllerClass:(Class)aClass {
    if (!aClass) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"NavigationClass cannot be nil" userInfo:nil];
    }
    [UENavigationBar appearanceInfo][NSStringFromClass(aClass)] = [UENavigationBarAppearance standardAppearance];
}

@end
