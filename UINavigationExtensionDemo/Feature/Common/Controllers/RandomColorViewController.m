//
//  RandomColorViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "RandomColorViewController.h"
#import "UIColor+RandomColor.h"

static CGFloat RandomColorButtonWidthAndHeight = 160.0;

@interface RandomColorViewController ()

@property (nonatomic, strong) UIColor *currentRandomColor;
@property (nonatomic, strong) UIButton *randomColorButton;

@end

@implementation RandomColorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _currentRandomColor = [UIColor randomColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navigationItem.title ?: NSStringFromClass([self class]);
    [self.view addSubview:self.randomColorButton];
    
    self.randomColorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.randomColorButton.widthAnchor constraintEqualToConstant:RandomColorButtonWidthAndHeight].active = YES;
    [self.randomColorButton.heightAnchor constraintEqualToConstant:RandomColorButtonWidthAndHeight].active = YES;
    [self.randomColorButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.randomColorButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    [self.navigationController ue_redirectViewControllerClass:[RandomColorViewController class] createViewControllerUsingBlock:^__kindof UIViewController * _Nonnull {
        return [[RandomColorViewController alloc] init];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor *)randomColor {
    return self.currentRandomColor;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    } else {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    }
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return self.currentRandomColor ?: [UIColor customLightGrayColor];
}

- (UIColor *)ue_barTintColor {
    return self.isDarkMode ? [UIColor whiteColor] : [UIColor blackColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self ue_barTintColor]};
}

#pragma mark - Action

- (void)clickRandomColorButton:(UIButton *)button {
    button.tag += 1;
    
    self.currentRandomColor = [UIColor randomColor];
    self.randomColorButton.layer.borderColor = self.currentRandomColor.CGColor;
    [self.randomColorButton setTitleColor:self.currentRandomColor forState:UIControlStateNormal];
    
    [self ue_setNeedsNavigationBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Getter

- (UIButton *)randomColorButton {
    if (!_randomColorButton) {
        _randomColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _randomColorButton.backgroundColor = [UIColor clearColor];
        _randomColorButton.layer.cornerRadius = RandomColorButtonWidthAndHeight * 0.5;
        _randomColorButton.layer.borderWidth = 5.0;
        _randomColorButton.layer.borderColor = self.currentRandomColor.CGColor;
        [_randomColorButton setTitleColor:self.currentRandomColor forState:UIControlStateNormal];
        [_randomColorButton setTitle:@"Update" forState:UIControlStateNormal];
        [_randomColorButton addTarget:self action:@selector(clickRandomColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomColorButton;
}

- (BOOL)isDarkMode {
    return self.randomColorButton.tag % 2 == 0;
}

@end
