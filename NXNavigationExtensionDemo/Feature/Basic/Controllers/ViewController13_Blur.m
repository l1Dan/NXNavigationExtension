//
//  ViewController13_Blur.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2021/5/4.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController13_Blur.h"
#import "UIColor+RandomColor.h"

@interface ViewController13_Blur ()

@property (nonatomic, strong) UIVisualEffectView *gaussianBlurView;

@end

@implementation ViewController13_Blur

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nx_navigationBar addSubview:self.gaussianBlurView];
    
    [self.gaussianBlurView.topAnchor constraintEqualToAnchor:self.nx_navigationBar.topAnchor].active = YES;
    [self.gaussianBlurView.leftAnchor constraintEqualToAnchor:self.nx_navigationBar.leftAnchor].active = YES;
    [self.gaussianBlurView.bottomAnchor constraintEqualToAnchor:self.nx_navigationBar.bottomAnchor].active = YES;
    [self.gaussianBlurView.rightAnchor constraintEqualToAnchor:self.nx_navigationBar.rightAnchor].active = YES;
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

#pragma mark - Getter & Setter

- (UIVisualEffectView *)gaussianBlurView {
    if (!_gaussianBlurView) {
        UIBlurEffect *effect;
        if (@available(iOS 13.0, *)) {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        _gaussianBlurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _gaussianBlurView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.backgroundColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return [UIColor redColor];
        } darkModeColor:^UIColor * _Nonnull{
            return [UIColor grayColor];
        }];
        [_gaussianBlurView.contentView addSubview:contentView];
        [_gaussianBlurView.contentView setAlpha:0.5];
        
        [contentView.topAnchor constraintEqualToAnchor:self.gaussianBlurView.topAnchor].active = YES;
        [contentView.leftAnchor constraintEqualToAnchor:self.gaussianBlurView.leftAnchor].active = YES;
        [contentView.bottomAnchor constraintEqualToAnchor:self.gaussianBlurView.bottomAnchor].active = YES;
        [contentView.rightAnchor constraintEqualToAnchor:self.gaussianBlurView.rightAnchor].active = YES;
    }
    return _gaussianBlurView;
}

@end
