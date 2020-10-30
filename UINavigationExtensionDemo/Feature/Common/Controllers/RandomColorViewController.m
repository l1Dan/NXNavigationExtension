//
//  RandomColorViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/30.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "RandomColorViewController.h"
#import "UIColor+RandomColor.h"

@interface RandomColorViewController ()

@property (nonatomic, strong) UIColor *changeColor;
@property (nonatomic, strong) UIButton *randomColorButton;

@end

@implementation RandomColorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _changeColor = [self randomColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navigationItem.title ?: NSStringFromClass([self class]);
    [self.view addSubview:self.randomColorButton];
}

- (UIColor *)randomColor {
    return [UIColor randomColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
    } else {
        return self.isDarkMode ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    }
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return self.changeColor ?: [UIColor customLightGrayColor];
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
    
    self.changeColor = [self randomColor];
    self.randomColorButton.layer.borderColor = self.changeColor.CGColor;
    [self.randomColorButton setTitleColor:self.changeColor forState:UIControlStateNormal];
    
    [self ue_setNeedsNavigationBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Getter

- (UIButton *)randomColorButton {
    if (!_randomColorButton) {
        CGFloat wh = 160.0;
        _randomColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _randomColorButton.bounds = CGRectMake(0, 0, wh, wh);
        _randomColorButton.center = self.view.center;
        _randomColorButton.backgroundColor = [UIColor clearColor];
        _randomColorButton.layer.cornerRadius = wh * 0.5;
        _randomColorButton.layer.borderWidth = 5.0;
        _randomColorButton.layer.borderColor = self.changeColor.CGColor;
        [_randomColorButton setTitleColor:self.changeColor forState:UIControlStateNormal];
        [_randomColorButton setTitle:@"Updated" forState:UIControlStateNormal];
        [_randomColorButton addTarget:self action:@selector(clickRandomColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomColorButton;
}

- (BOOL)isDarkMode {
    return self.randomColorButton.tag % 2 == 0;
}

@end
