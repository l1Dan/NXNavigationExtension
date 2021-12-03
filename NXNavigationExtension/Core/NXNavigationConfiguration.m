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
#import "NXNavigationExtensionRuntime.h"

// chevron.left@2x.png, SF Pro-Medium, compression, 默认颜色：tintColor = [UIColor whiteColor]
static NSString *NXNavigationBarBackImageBase64Data = @"iVBORw0KGgoAAAANSUhEUgAAABQAAAAjCAMAAACjKNoqAAAAgVBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9d3yJTAAAAK3RSTlMA2QUR1K2xGAzHwaWblI+Ld2hQJ83Mu7e1n5iJfXJsY11IQC0dCINYOSIHKsEspwAAAKhJREFUKM990ckSgjAURNEEJKDMCDIo4Dz9/wcqnU06przLs3ld9YTds6h+bJZSlpaV8ptim+RSTjbCWt+0AtaRHWDKYQHZXVtk2h4Wk+XabgZ5GawnS2GJZ9oAG8gSWGrau4dlMN6SC6rGDcGpBVdnxkvt1AZ6Yt2u/2jlUmnpawN9sF61Hp06s4Y7aOnUydIWOrL6HbSwVNkboAGeL7ho0VTYmjVx+AEgOgfYXg2whAAAAABJRU5ErkJggg==";


static NSString *NXNavigationConfigurationKey = @"NXNavigationConfigurationKey";
static NSString *NXNavigationConfigurationCallbackKey = @"NXNavigationConfigurationCallbackKey";


@interface NXNavigationBarAppearance ()

@property (nonatomic, strong) NSData *imageData;

@end


@implementation NXNavigationBarAppearance

- (instancetype)init {
    if (self = [super init]) {
        _backgroundColor = [UIColor systemBlueColor];
        _useSystemBackButton = NO;
        _systemBackButtonTitle = @"";
        _backImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _landscapeBackImageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _imageData = [[NSData alloc] initWithBase64EncodedString:NXNavigationBarBackImageBase64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        _tintColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            _tintColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                return (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ? [UIColor whiteColor] : [UIColor blackColor];
            }];
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
    newAppearance.landscapeBackImage = self.landscapeBackImage;
    
    newAppearance.backImageInsets = self.backImageInsets;
    newAppearance.landscapeBackImageInsets = self.landscapeBackImageInsets;
    
    newAppearance.useSystemBackButton = self.useSystemBackButton;
    newAppearance.systemBackButtonTitle = self.systemBackButtonTitle;

    return newAppearance;
}

#pragma mark - Getter

- (UIImage *)backImage {
    if (!_backImage) {
        if (self.imageData) {
            _backImage = [UIImage imageWithData:self.imageData scale:2.0];
        }
    }
    return _backImage;
}

- (UIImage *)landscapeBackImage {
    if (!_landscapeBackImage) {
        if (self.imageData) {
            _landscapeBackImage = [UIImage imageWithData:self.imageData scale:3.0];
        }
    }
    return _landscapeBackImage;
}

@end


@implementation NXNavigationControllerPreferences

- (instancetype)init {
    if (self = [super init]) {
        _fullScreenInteractivePopGestureEnabled = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NXNavigationControllerPreferences *newPreferences = [[NXNavigationControllerPreferences alloc] init];
    newPreferences.fullScreenInteractivePopGestureEnabled = self.fullScreenInteractivePopGestureEnabled;
    return newPreferences;
}

@end


@interface NXViewControllerPreferences ()

@property (nonatomic, strong) UITraitCollection *traitCollection;

@end


@implementation NXViewControllerPreferences

- (instancetype)init {
    if (self = [super init]) {
        _useBlurNavigationBar = NO;
        _disableInteractivePopGesture = NO;
        _enableFullScreenInteractivePopGesture = NO;
        _automaticallyHideNavigationBarInChildViewController = YES;
        _translucentNavigationBar = NO;
        _systemNavigationBarUserInteractionDisabled = NO;
        _interactivePopMaxAllowedDistanceToLeftEdge = 0.0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    NXViewControllerPreferences *newPreferences = [[NXViewControllerPreferences alloc] init];
    newPreferences.useBlurNavigationBar = self.useBlurNavigationBar;
    newPreferences.disableInteractivePopGesture = self.disableInteractivePopGesture;
    newPreferences.enableFullScreenInteractivePopGesture = self.enableFullScreenInteractivePopGesture;
    newPreferences.automaticallyHideNavigationBarInChildViewController = self.automaticallyHideNavigationBarInChildViewController;
    newPreferences.translucentNavigationBar = self.translucentNavigationBar;
    newPreferences.systemNavigationBarUserInteractionDisabled = self.systemNavigationBarUserInteractionDisabled;
    newPreferences.interactivePopMaxAllowedDistanceToLeftEdge = self.interactivePopMaxAllowedDistanceToLeftEdge;
    return newPreferences;
}

@end


@interface NXNavigationConfiguration ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *registerClassesInfo;

@end


@implementation NXNavigationConfiguration

+ (NXNavigationConfiguration *)defaultConfiguration {
    static NXNavigationConfiguration *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NXNavigationConfiguration alloc] init];
    });
    return instance;
}

#pragma mark - Private

+ (NSDictionary<NSString *, id> *)lookupConfigurationInfoWithNavigationControllerClass:(__kindof Class)navigationControllerClass {
    if (!navigationControllerClass) return nil;
    // 收集所有的类
    NSMutableArray<Class> *classes = [NSMutableArray array];
    for (NSString *className in [NXNavigationConfiguration defaultConfiguration].registerClassesInfo.allKeys) {
        if (NSClassFromString(className)) {
            [classes addObject:NSClassFromString(className)];
        }
    }
    // 查找到最适合那个类对象
    Class aClass = NXNavigationExtensionLookupClass(navigationControllerClass, classes);
    if (aClass) {
        return [NXNavigationConfiguration defaultConfiguration].registerClassesInfo[NSStringFromClass(aClass)];
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    NXNavigationConfiguration *newConfiguration = [[NXNavigationConfiguration alloc] init];
    newConfiguration.navigationBarAppearance = [self.navigationBarAppearance copy];
    newConfiguration.navigationControllerPreferences = [self.navigationControllerPreferences copy];
    newConfiguration.viewControllerPreferences = [self.viewControllerPreferences copy];
    return newConfiguration;
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *,NSDictionary<NSString *,id> *> *)registerClassesInfo {
    if (!_registerClassesInfo) {
        _registerClassesInfo = [NSMutableDictionary dictionary];
    }
    return _registerClassesInfo;
}

- (NXNavigationBarAppearance *)navigationBarAppearance {
    if (!_navigationBarAppearance) {
        _navigationBarAppearance = [[NXNavigationBarAppearance alloc] init];
    }
    return _navigationBarAppearance;
}

- (NXNavigationControllerPreferences *)navigationControllerPreferences {
    if (!_navigationControllerPreferences) {
        _navigationControllerPreferences = [[NXNavigationControllerPreferences alloc] init];
    }
    return _navigationControllerPreferences;
}

- (NXViewControllerPreferences *)viewControllerPreferences {
    if (!_viewControllerPreferences) {
        _viewControllerPreferences = [[NXViewControllerPreferences alloc] init];
    }
    return _viewControllerPreferences;
}

#pragma mark - Public

- (void)registerNavigationControllerClasses:(NSArray<Class> *)navigationControllerClasses {
    [self registerNavigationControllerClasses:navigationControllerClasses prepareConfigureNavigationControllerCallback:NULL];
}

- (void)registerNavigationControllerClasses:(NSArray<Class> *)navigationControllerClasses prepareConfigureNavigationControllerCallback:(NXNavigationControllerPrepareConfigurationCallback)callback {
    NSAssert(navigationControllerClasses != nil, @"参数 navigationControllerClasses 不能为空！");
    
    NXNavigationConfiguration *configuration = self;
    for (Class navigationControllerClass in navigationControllerClasses) {
        NSMutableDictionary<NSString *, id> *info = [NSMutableDictionary dictionary];
        [info setValue:configuration forKey:NXNavigationConfigurationKey];
        [info setValue:callback forKey:NXNavigationConfigurationCallbackKey];
        [NXNavigationConfiguration defaultConfiguration].registerClassesInfo[NSStringFromClass(navigationControllerClass)] = info;
    }
}

+ (NXNavigationConfiguration *)configurationFromNavigationControllerClass:(Class)navigationControllerClass {
    NSDictionary<NSString *, id> *info = [NXNavigationConfiguration lookupConfigurationInfoWithNavigationControllerClass:navigationControllerClass];
    return info ? info[NXNavigationConfigurationKey] : info;
}

+ (nullable NXNavigationControllerPrepareConfigurationCallback)prepareConfigurationCallbackFromNavigationControllerClass:(Class)navigationControllerClass {
    NSDictionary<NSString *, id> *info = [NXNavigationConfiguration lookupConfigurationInfoWithNavigationControllerClass:navigationControllerClass];
    return info ? info[NXNavigationConfigurationCallbackKey] : info;
}

@end
