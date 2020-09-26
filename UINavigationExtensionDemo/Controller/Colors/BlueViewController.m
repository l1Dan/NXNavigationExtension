//
//  BlueViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "BlueViewController.h"

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor redColor];
}

- (UIView *)ue_backButtonCustomView {
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 4, 44)];
    text.backgroundColor = [UIColor redColor];
    text.text = @"1111";
    
    
    return text;
}

@end
