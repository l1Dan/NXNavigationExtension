//
//  BaseViewController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/29.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "BaseViewController.h"
#import "UIColor+RandomColor.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, strong) UIColor *darkColor;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor customBackgroundColor];
}

- (void)dealloc {
    NSLog(@"Dealloced: %@", NSStringFromClass([self class]));
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

- (UIColor *)nx_barTintColor {
    return [UIColor customTitleColor];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor lightGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
    }];
}

#pragma mark - Getter

- (UIColor *)lightColor {
    if (!_lightColor) {
        _lightColor = [UIColor randomLightColor];
    }
    return _lightColor;
}

- (UIColor *)darkColor {
    if (!_darkColor) {
        _darkColor = [UIColor randomDarkColor];
    }
    return _darkColor;
}

- (UIColor *)randomColor {
    if (!_randomColor) {
        __weak typeof(self) weakSelf = self;
        _randomColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return weakSelf.lightColor;
        } darkModeColor:^UIColor * _Nonnull{
            return weakSelf.darkColor;
        }];
    }
    return _randomColor;
}

@end
