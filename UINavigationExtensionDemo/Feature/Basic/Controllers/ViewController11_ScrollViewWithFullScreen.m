//
//  ViewController11_ScrollViewWithFullScreen.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController11_ScrollViewWithFullScreen.h"

@interface ViewController11_ScrollViewWithFullScreen ()

@end

@implementation ViewController11_ScrollViewWithFullScreen

- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGFloat maxHeight = CGRectGetHeight(self.ue_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
    self.navigationItem.title = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)ue_barTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

@end
