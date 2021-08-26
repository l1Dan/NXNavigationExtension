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

#import "NXNavigationBar.h"

static NSString *NXNavigationBarAppearanceNackImageBase64 = @"iVBORw0KGgoAAAANSUhEUgAAABgAAAAoCAMAAADT08pnAAAAhFBMVEUAAAAAg/8Ae/8AfP8Aev8Aev8Aev8Aev8Aev8Aev8Ae/8Aev8Aev8Ae/8AfP8Ae/8Aff8Afv8Ag/8Ahv8AiP8AjP8Aev8Aev8Ae/8Aev8Aev8Ae/8Ae/8Aff8Ae/8Af/8Afv8Aev8Aev8Ae/8Aev8Ae/8Ae/8Aev8Ae/8AfP8Aff8Aev+lPeVOAAAAK3RSTlMABv1G+fXr4dvW0cvAtTw4JSAWEg4K8u/mxrp1XEExKxuvpKB5b2ljUk1WM3boWAAAAMVJREFUKM9109cWgjAMBuAqigwZboaAIg7s+7+fI+3JaUL+yy8XhQzFMxviypvyq/4m5Z7oX27UD5X+p6e+1hDyyN56Tbw0fnd9Fxt/EI+A50/Xt9bPxMNpvwTgi5frG+sj8RX40nM9l7wAPzaud9ZT4j74KSP9D8H9VrnJjHdKKLRslJF5glXyAh+nv4efKzSkYZUAWyI0fWSVEMchDPCNxkdOlweXRF4reRHF1ZWWfZDOQ3vCQelePDXhOOcpAqYuk0Z9AKe5MI4L1d4yAAAAAElFTkSuQmCC";


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

@property (nonatomic, assign) CGRect originalNavigationBarFrame;
@property (nonatomic, assign) UIEdgeInsets containerViewEdgeInsets;
@property (nonatomic, assign) BOOL edgesForExtendedLayoutEnabled;

@end

@implementation NXNavigationBar

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
        _edgesForExtendedLayoutEnabled = NO;
        
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _visualEffectView.hidden = YES;
        _backgroundImageView.image = [NXNavigationBarAppearance standardAppearance].backgorundImage;
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.visualEffectView];
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

- (void)updateNavigationBarContentFrameCallSuper:(BOOL)callSuper {
    CGRect navigationBarFrame = CGRectMake(0, 0, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame));
    self.visualEffectView.frame = navigationBarFrame;
    self.backgroundImageView.frame = navigationBarFrame;
    
    CGRect containerViewFrame = CGRectMake(0, CGRectGetMinY(_originalNavigationBarFrame), CGRectGetWidth(_originalNavigationBarFrame), CGRectGetHeight(_originalNavigationBarFrame));
    self.containerView.frame = UIEdgeInsetsInsetRect(containerViewFrame, _containerViewEdgeInsets);
    
    CGFloat shadowImageViewHeight = 1.0 / UIScreen.mainScreen.scale;
    self.shadowImageView.frame = CGRectMake(0, CGRectGetMaxY(_originalNavigationBarFrame) - shadowImageViewHeight, CGRectGetWidth(navigationBarFrame), shadowImageViewHeight);
    
    // 放在所有的 View 前面，防止 containerView 被遮挡
    if (self.superview && self.superview != self.containerView && self.superview != self.containerView.superview) {
        [self.superview addSubview:self.containerView];
    }
    [self.superview bringSubviewToFront:self.containerView];
    
    // 重新设置 NavigationBar frame
    if (callSuper) {
        CGFloat navigationBarY = self.edgesForExtendedLayoutEnabled ? CGRectGetHeight(navigationBarFrame) : 0;
        [super setFrame:CGRectMake(0, -navigationBarY, CGRectGetWidth(_originalNavigationBarFrame), CGRectGetMaxY(_originalNavigationBarFrame))];
    }
}

+ (NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *)appearanceInfo {
    static NSMutableDictionary<NSString *, NXNavigationBarAppearance *> *appearanceInfo = nil;
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

- (void)addContainerViewSubview:(UIView *)subview {
    if (subview != self.containerView) {
        [self.containerView addSubview:subview];
    }
}

- (void)setContainerViewEdgeInsets:(UIEdgeInsets)edgeInsets {
    _containerViewEdgeInsets = edgeInsets;
    [self updateNavigationBarContentFrameCallSuper:NO];
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
    if (!appearance) {
        appearance = [NXNavigationBarAppearance standardAppearance];
    }
    
    [NXNavigationBar appearanceInfo][NSStringFromClass(aClass)] = appearance;
}

@end
