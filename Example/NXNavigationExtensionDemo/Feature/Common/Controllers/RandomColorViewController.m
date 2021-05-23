//
//  RandomColorViewController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "RandomColorViewController.h"
#import "UIColor+RandomColor.h"

static CGFloat RandomColorButtonWidthAndHeight = 160.0;

@interface RandomColorViewController ()

@property (nonatomic, strong) UIColor *currentRandomColor;
@property (nonatomic, strong) UIColor *lightRandomColor;
@property (nonatomic, strong) UIColor *darkRandomColor;
@property (nonatomic, strong) UIButton *randomColorButton;

@end

@implementation RandomColorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _lightRandomColor = [UIColor randomLightColor];
        _darkRandomColor = [UIColor randomDarkColor];
        
        _currentRandomColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return self.lightRandomColor;
        } darkModeColor:^UIColor * _Nonnull{
            return self.darkRandomColor;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationItem.title ?: NSStringFromClass([self class]);
    [self.view addSubview:self.randomColorButton];
    
    [self updateRandomColorButtonState];
    [self.randomColorButton.widthAnchor constraintEqualToConstant:RandomColorButtonWidthAndHeight].active = YES;
    [self.randomColorButton.heightAnchor constraintEqualToConstant:RandomColorButtonWidthAndHeight].active = YES;
    [self.randomColorButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.randomColorButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    } else {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self updateRandomColorButtonState];
}

- (UIColor *)randomColor {
    return self.currentRandomColor;
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return self.currentRandomColor ?: [UIColor customLightGrayColor];
}

- (UIColor *)nx_barTintColor {
    return self.isDarkMode ? [UIColor whiteColor] : [UIColor blackColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

#pragma mark - Private

- (void)updateRandomColorButtonState {
    self.randomColorButton.layer.borderColor = self.currentRandomColor.CGColor;
    [self.randomColorButton setTitleColor:self.currentRandomColor forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        [self.randomColorButton setTitleColor:[self.currentRandomColor resolvedColorWithTraitCollection:self.view.traitCollection] forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (void)clickRandomColorButton:(UIButton *)button {
    button.tag += 1;
    
    self.lightRandomColor = [UIColor randomLightColor];
    self.darkRandomColor = [UIColor randomDarkColor];
    [self updateRandomColorButtonState];
    [self nx_setNeedsNavigationBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Getter

- (UIButton *)randomColorButton {
    if (!_randomColorButton) {
        _randomColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _randomColorButton.backgroundColor = [UIColor clearColor];
        _randomColorButton.translatesAutoresizingMaskIntoConstraints = NO;
        _randomColorButton.layer.cornerRadius = RandomColorButtonWidthAndHeight * 0.5;
        _randomColorButton.layer.borderWidth = 5.0;
        [_randomColorButton setTitle:@"Update" forState:UIControlStateNormal];
        [_randomColorButton addTarget:self action:@selector(clickRandomColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomColorButton;
}

- (BOOL)isDarkMode {
    return self.randomColorButton.tag % 2 == 0;
}

@end
