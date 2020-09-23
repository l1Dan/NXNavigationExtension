//
//  UEConfiguration.m
//  UINavigationExtension
//
//  Created by lidan on 2020/9/22.
//

#import "UEConfiguration.h"

@interface UEConfiguration()

@property (nonatomic, strong) UIImage *defualtBackImage;

@end

@implementation UEConfiguration

+ (UEConfiguration *)defaultConfiguration {
    static UEConfiguration *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UEConfiguration alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _tintColor = [UIColor systemBlueColor];
        _backgorundColor = [UIColor whiteColor];
        _fullscreenPopGestureEnable = NO;
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

- (CGFloat)navigationBarHeight {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = nil;
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
            }
        }
        
        CGFloat top = keyWindow.safeAreaInsets.top;
        return top > 20.0 ? 88.0 : 64.0;
    } else {
        return 64.0;
    }
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGSize size = CGSizeMake(1.0, 1.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
