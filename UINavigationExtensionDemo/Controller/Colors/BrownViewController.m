//
//  BrownViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "BrownViewController.h"
#import "UIBarButtonItem+Convenience.h"

@interface BrownViewController() <UINavigationControllerCustomizable, UIAlertViewDelegate>

@end

@implementation BrownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
}

/// 自定义返回按钮点击返回
- (void)clickBackItem:(UIBarButtonItem *)item {
    [self ue_triggerSystemBackButtonHandle];
}

#pragma makr - UINavigationControllerCustomizable
- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewControllerUsingInteractivePopGesture:(BOOL)usingGesture {
    if (usingGesture) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否返回到上个页面？" preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];

        [self.navigationController presentViewController:controller animated:YES completion:NULL];
        return NO;
    } else {
        return YES;
    }
}

@end
