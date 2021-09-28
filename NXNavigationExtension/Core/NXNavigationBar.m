//
// NXNavigationBar.m
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import <objc/runtime.h>

#import "NXNavigationBar.h"

// <@2x.png, 默认颜色：tintColor = [UIColor systemBlueColor]
static NSString *NXNavigationBarAppearanceNackImageBase64 = @"iVBORw0KGgoAAAANSUhEUgAAABgAAAAoCAMAAADT08pnAAAAflBMVEUAAAAAkP8Aev8Ae/8Aev8Ae/8AkP8Aev8Aev8Ae/8Ae/8AfP8Afv8Afv8Af/8Aev8Aev8Ae/8Ae/8Ae/8Ae/8Aev8Aev8Ae/8Ae/8Aev8AfP8Afv8Ae/8Ae/8Ae/8Aev8Ae/8Ae/8Aev8Ae/8AfP8Aff8Ae/8AgP8AhP8Aev+USLvdAAAAKXRSTlMAAvT6910F6uFHPDcsIh3x7ubcs62lkItoYU8nzp+alYWAeXRvQDEQDnA4PYMAAAC0SURBVCjPhdNJFoIwEARQjEScEBFRcB5Qyf0vKHZ2Vd3PWv4skvSQKPm0eaLFpyF4xdsw5MTehF8q8k58PEd/Rj+gP8TTGfrd8Ju4e6Hvo9O9O/FiATy6iq/JL9Hf6GfxbIle6z7ZipdH3afkVfRcf/9mRX107JIeDqBEcgU9yjyp4Rv48RI+zqXi4mZQXG6H3UD+TwEtpyH5P1Y8iProUjrzpIE14MWxV43jXVxOTu+HRn8B1TglOoU3GxgAAAAASUVORK5CYII=";


@implementation NXNavigationBarAppearance

+ (NXNavigationBarAppearance *)standardAppearance {
    static NXNavigationBarAppearance *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXNavigationBarAppearance alloc] init];
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
        
        if (@available(iOS 14.0, *)) {
            self.backButtonMenuSupported = NO;
        }
    }
    return self;
}

#pragma mark - Getter

- (UIImage *)backImage {
    if (!_backImage) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:NXNavigationBarAppearanceNackImageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (data) {
            return [UIImage imageWithData:data scale:2.0];
        }
        return nil;
    }
    return _backImage;
}

- (UIImage *)landscapeBackImage {
    if (!_landscapeBackImage) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:NXNavigationBarAppearanceNackImageBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (data) {
            return [UIImage imageWithData:data scale:3.0];
        }
        return nil;
    }
    return _landscapeBackImage;
}

- (void)setBackButtonMenuSupported:(BOOL)backButtonMenuSupported {
    _backButtonMenuSupported = backButtonMenuSupported;
    if (backButtonMenuSupported) {
        _backImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _landscapeBackImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    } else {
        _backImageInsets = UIEdgeInsetsZero;
        _landscapeBackImageInsets = UIEdgeInsetsZero;
    }
}

@end


@interface NXNavigationBar ()

@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, assign) CGRect originalNavigationBarFrame;
@property (nonatomic, assign) BOOL edgesForExtendedLayoutEnabled;
@property (nonatomic, assign) BOOL blurEffectEnabled;

@property (nonatomic, copy, class) NXNavigationBarAppearance * _Nullable(^navigationControllerAppearanceBlock)(__kindof UINavigationController *);

@end


@implementation NXNavigationBar

@dynamic navigationControllerAppearanceBlock;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _originalBackgroundColor = [NXNavigationBarAppearance standardAppearance].backgorundColor;
        _originalNavigationBarFrame = CGRectZero;
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImageView.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentViewEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        _edgesForExtendedLayoutEnabled = NO;
        
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _backgroundEffectView.hidden = YES;
        _blurEffectEnabled = NO;
        _backgroundImageView.image = [NXNavigationBarAppearance standardAppearance].backgorundImage;
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backgroundEffectView];
        [self addSubview:self.shadowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateNavigationBarContentFrameCallSuper:NO];
}

- (void)setFrame:(CGRect)frame {
    _originalNavigationBarFrame = frame;
    
    [self updateNavigationBarContentFrameCallSuper:YES];
}

#pragma mark - Private

+ (NXNavigationBarAppearance * _Nullable (^)(__kindof UINavigationController *))navigationControllerAppearanceBlock {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setNavigationControllerAppearanceBlock:(NXNavigationBarAppearance * _Nullable (^)(__kindof UINavigationController *))navigationControllerAppearanceBlock {
    objc_setAssociatedObject(self, @selector(navigationControllerAppearanceBlock), navigationControllerAppearanceBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setBlurEffectEnabled:(BOOL)blurEffectEnabled {
    _blurEffectEnabled = blurEffectEnabled;
    [self setBackgroundColor:self.originalBackgroundColor];
}

- (void)updateNavigationBarContentFrameCallSuper:(BOOL)callSuper {
    CGRect navigationBarFrame = CGRectMake(0, 0, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame));
    self.backgroundEffectView.frame = navigationBarFrame;
    self.backgroundImageView.frame = navigationBarFrame;
    
    CGRect contentViewFrame = CGRectMake(0, CGRectGetMinY(_originalNavigationBarFrame), CGRectGetWidth(_originalNavigationBarFrame), CGRectGetHeight(_originalNavigationBarFrame));
    self.contentView.frame = UIEdgeInsetsInsetRect(contentViewFrame, _contentViewEdgeInsets);
    
    CGFloat shadowImageViewHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, CGRectGetMaxY(_originalNavigationBarFrame) - shadowImageViewHeight, CGRectGetWidth(navigationBarFrame), shadowImageViewHeight);
    
    // 放在所有的 View 前面，防止 contentView 被遮挡
    if (self.superview && self.superview != self.contentView && self.superview != self.contentView.superview) {
        [self.superview addSubview:self.contentView];
    }
    [self.superview bringSubviewToFront:self.contentView];
    
    // 重新设置 NavigationBar frame
    if (callSuper) {
        CGFloat navigationBarY = self.edgesForExtendedLayoutEnabled ? CGRectGetHeight(navigationBarFrame) : 0;
        [super setFrame:CGRectMake(0, -navigationBarY, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame))];
    }
}

#pragma mark - Public

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.originalBackgroundColor = backgroundColor;
    if (self.blurEffectEnabled) {
        self.backgroundImageView.hidden = YES;
        self.backgroundEffectView.hidden = NO;
        self.backgroundEffectView.contentView.backgroundColor = backgroundColor;
        
        [super setBackgroundColor:[UIColor clearColor]];
    } else {
        self.backgroundImageView.hidden = NO;
        self.backgroundEffectView.hidden = YES;
        
        [super setBackgroundColor:backgroundColor];
    }
}

- (void)setContentViewEdgeInsets:(UIEdgeInsets)contentViewEdgeInsets {
    _contentViewEdgeInsets = contentViewEdgeInsets;
    [self updateNavigationBarContentFrameCallSuper:NO];
}

+ (NXNavigationBarAppearance *)appearanceInNavigationController:(__kindof UINavigationController *)navigationController {
    if (self.navigationControllerAppearanceBlock) {
        return self.navigationControllerAppearanceBlock(navigationController);
    }
    return nil;
}

+ (void)setAppearanceForNavigationControllerUsingBlock:(NXNavigationBarAppearance * _Nullable (^)(__kindof UINavigationController * _Nonnull))block {
    self.navigationControllerAppearanceBlock = block;
}

@end
