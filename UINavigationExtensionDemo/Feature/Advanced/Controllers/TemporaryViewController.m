//
//  RandomColorViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/30.
//

#import "RandomColorViewController.h"
#import "UIColor+RandomColor.h"

@interface RandomColorViewController ()

@property (nonatomic, strong) UIButton *randomColorButton;

@end

@implementation RandomColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.randomColorButton];
}

- (UIColor *)randomColor {
    return [UIColor randomColor];
}

#pragma mark - Action

- (void)clickRandomColorButton:(UIButton *)button {
    UIColor *randomColor = [self randomColor];
    self.randomColorButton.layer.borderColor = randomColor.CGColor;
    [self.randomColorButton setTitleColor:randomColor forState:UIControlStateNormal];
}

#pragma mark - Getter

- (UIButton *)randomColorButton {
    if (!_randomColorButton) {
        UIColor *randomColor = [self randomColor];
        CGFloat wh = 160.0;
        _randomColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _randomColorButton.bounds = CGRectMake(0, 0, wh, wh);
        _randomColorButton.center = self.view.center;
        _randomColorButton.backgroundColor = [UIColor clearColor];
        _randomColorButton.layer.cornerRadius = wh * 0.5;
        _randomColorButton.layer.borderWidth = 5.0;
        _randomColorButton.layer.borderColor = randomColor.CGColor;
        [_randomColorButton setTitleColor:randomColor forState:UIControlStateNormal];
        [_randomColorButton setTitle:@"Random" forState:UIControlStateNormal];
        [_randomColorButton addTarget:self action:@selector(clickRandomColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomColorButton;
}

@end
