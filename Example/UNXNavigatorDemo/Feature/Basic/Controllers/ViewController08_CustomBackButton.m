//
//  ViewController08_CustomBackButton.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UNXNavigator/UNXNavigator.h>

#import "ViewController08_CustomBackButton.h"
#import "UIColor+RandomColor.h"

@interface ViewController08_CustomBackButton ()

@end

@implementation ViewController08_CustomBackButton

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)unx_backButtonCustomView {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"😋" forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"NavigationBarBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backButton setTitleColor:UIColor.customDarkGrayColor forState:UIControlStateNormal];
    [backButton setTintColor:UIColor.customTitleColor];
    return backButton;
}

@end
