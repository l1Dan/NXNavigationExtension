//
//  BaseViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/29.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "BaseViewController.h"
#import "UIColor+RandomColor.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.randomColor;
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor customLightGrayColor];
}

#pragma mark - Getter

- (UIColor *)randomColor {
    if (!_randomColor) {
        _randomColor = [UIColor randomColor];
    }
    return _randomColor;
}

@end
