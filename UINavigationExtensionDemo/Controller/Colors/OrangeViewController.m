//
//  OrangeViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "OrangeViewController.h"
#import "GrayViewController.h"
#import "BlueViewController.h"

@interface OrangeViewController () <UINavigationControllerCustomizable>

@end

@implementation OrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark - UINavigationControllerCustomizable
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewControllerUsingInteractivePopGesture:(BOOL)usingGesture {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否离开当前页面？" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];

    [self.navigationController presentViewController:controller animated:YES completion:NULL];
    
    return NO;
}

@end
