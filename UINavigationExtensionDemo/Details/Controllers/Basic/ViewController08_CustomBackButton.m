//
//  ViewController08_CustomBackButton.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import "ViewController08_CustomBackButton.h"
#import "UIColor+RandomColor.h"

@interface ViewController08_CustomBackButton ()

@end

@implementation ViewController08_CustomBackButton

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)ue_backButtonCustomView {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
    [backButton setTitleColor:UIColor.customDarkGrayColor forState:UIControlStateNormal];
    return backButton;
}

@end
