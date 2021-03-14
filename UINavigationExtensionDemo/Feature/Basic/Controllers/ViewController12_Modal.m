//
//  ViewController12_Modal.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController12_Modal.h"
#import "UIImage+NavigationBar.h"
#import "UIColor+RandomColor.h"

@interface ViewController12_Modal ()

@end

@implementation ViewController12_Modal

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 36, 36);
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setImage:[[UIImage imageNamed:@"NavigationBarClose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [closeButton setTintColor:UIColor.customTitleColor];
    [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)clickCloseButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
