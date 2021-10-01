//
// NXNavigationConfiguration.m
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

#import "NXNavigationConfiguration.h"

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
            _backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    NXNavigationBarAppearance *newAppearance = [[NXNavigationBarAppearance alloc] init];
    newAppearance.tintColor = self.tintColor;
    newAppearance.barTintColor = self.barTintColor;
    
    newAppearance.shadowImage = self.shadowImage;
    newAppearance.shadowColor = self.shadowColor;
    
    newAppearance.titleTextAttributes = self.titleTextAttributes;
    if (@available(iOS 11.0, *)) {
        newAppearance.largeTitleTextAttributes = self.largeTitleTextAttributes;
    }
    
    newAppearance.backgroundColor = self.backgroundColor;
    newAppearance.backgroundImage = self.backgroundImage;
    
    newAppearance.backButtonCustomView = self.backButtonCustomView;
    newAppearance.backImage = self.backImage;
    newAppearance.backImageInsets = self.backImageInsets;
    
    newAppearance.landscapeBackImage = self.landscapeBackImage;
    newAppearance.landscapeBackImageInsets = self.landscapeBackImageInsets;

    return newAppearance;
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

- (NSDictionary<NSAttributedStringKey,id> *)largeTitleTextAttributes {
    if (!_largeTitleTextAttributes) {
        _largeTitleTextAttributes = self.titleTextAttributes;
    }
    return _largeTitleTextAttributes;
}

@end


@implementation NXNavigationControllerPreferences

+ (NXNavigationControllerPreferences *)standardPreferences {
    static NXNavigationControllerPreferences *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXNavigationControllerPreferences alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _fullscreenInteractivePopGestureEnabled = NO;
        _menuSupplementBackButton = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NXNavigationControllerPreferences *newPreferences = [[NXNavigationControllerPreferences alloc] init];
    newPreferences.fullscreenInteractivePopGestureEnabled = self.fullscreenInteractivePopGestureEnabled;
    if (@available(iOS 14.0, *)) {
        newPreferences.menuSupplementBackButton = self.menuSupplementBackButton;
    }
    return newPreferences;
}

- (void)setFullscreenInteractivePopGestureEnabled:(BOOL)fullscreenInteractivePopGestureEnabled {
    _fullscreenInteractivePopGestureEnabled = fullscreenInteractivePopGestureEnabled;
}

@end


@implementation NXViewControllerPreferences

+ (NXViewControllerPreferences *)standardPreferences {
    static NXViewControllerPreferences *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXViewControllerPreferences alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _useBlurNavigationBar = NO;
        _disableInteractivePopGesture = NO;
        _enableFullscreenInteractivePopGesture = NO;
        _automaticallyHideNavigationBarInChildViewController = YES;
        _translucentNavigationBar = NO;
        _contentViewWithoutNavigtionBar = NO;
        _backButtonMenuEnabled = NO;
        _interactivePopMaxAllowedDistanceToLeftEdge = 0.0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NXViewControllerPreferences *newPreferences = [[NXViewControllerPreferences alloc] init];
    newPreferences.useBlurNavigationBar = self.useBlurNavigationBar;
    newPreferences.disableInteractivePopGesture = self.disableInteractivePopGesture;
    newPreferences.enableFullscreenInteractivePopGesture = self.enableFullscreenInteractivePopGesture;
    newPreferences.automaticallyHideNavigationBarInChildViewController = self.automaticallyHideNavigationBarInChildViewController;
    newPreferences.translucentNavigationBar = self.translucentNavigationBar;
    newPreferences.contentViewWithoutNavigtionBar = self.contentViewWithoutNavigtionBar;
    newPreferences.interactivePopMaxAllowedDistanceToLeftEdge = self.interactivePopMaxAllowedDistanceToLeftEdge;
    if (@available(iOS 14.0, *)) {
        newPreferences.backButtonMenuEnabled = self.backButtonMenuEnabled;
    }
    return newPreferences;
}

@end


@implementation NXNavigationConfiguration
@synthesize navigationControllerPreferences = _navigationControllerPreferences;

+ (NXNavigationConfiguration *)defaultConfiguration {
    static NXNavigationConfiguration *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXNavigationConfiguration alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        if (@available(iOS 14.0, *)) {
            [self updateNavigationBarAppearanceAllEdgeInsetsWithmenuSupplementBackButton:self.navigationControllerPreferences.menuSupplementBackButton];
        }
    }
    return self;
}

- (NXNavigationBarAppearance *)navigationBarAppearance {
    if (!_navigationBarAppearance) {
        _navigationBarAppearance = [[NXNavigationBarAppearance standardAppearance] copy];
    }
    return _navigationBarAppearance;
}

- (NXNavigationControllerPreferences *)navigationControllerPreferences {
    if (!_navigationControllerPreferences) {
        _navigationControllerPreferences = [[NXNavigationControllerPreferences standardPreferences] copy];
    }
    return _navigationControllerPreferences;
}

- (NXViewControllerPreferences *)viewControllerPreferences {
    if (!_viewControllerPreferences) {
        _viewControllerPreferences = [[NXViewControllerPreferences standardPreferences] copy];
    }
    return _viewControllerPreferences;
}

- (id)copyWithZone:(NSZone *)zone {
    NXNavigationConfiguration *newConfiguration = [[NXNavigationConfiguration alloc] init];
    newConfiguration.navigationBarAppearance = [self.navigationBarAppearance copy];
    newConfiguration.navigationControllerPreferences = [self.navigationControllerPreferences copy];
    newConfiguration.viewControllerPreferences = [self.viewControllerPreferences copy];
    return newConfiguration;
}

- (void)setNavigationControllerPreferences:(NXNavigationControllerPreferences *)navigationControllerPreferences {
    _navigationControllerPreferences = navigationControllerPreferences;

    if (@available(iOS 14.0, *)) {
        [self updateNavigationBarAppearanceAllEdgeInsetsWithmenuSupplementBackButton:navigationControllerPreferences.menuSupplementBackButton];
    }
}

- (void)updateNavigationBarAppearanceAllEdgeInsetsWithmenuSupplementBackButton:(BOOL)supported {
    if (supported) {
        self.navigationBarAppearance.backImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        self.navigationBarAppearance.landscapeBackImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    } else {
        self.navigationBarAppearance.backImageInsets = UIEdgeInsetsZero;
        self.navigationBarAppearance.landscapeBackImageInsets = UIEdgeInsetsZero;
    }
}

@end
