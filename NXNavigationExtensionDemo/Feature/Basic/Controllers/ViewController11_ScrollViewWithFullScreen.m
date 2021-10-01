//
//  ViewController11_ScrollViewWithFullscreen.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController11_ScrollViewWithFullScreen.h"

@interface ViewController11_ScrollViewWithFullscreen ()

@end

@implementation ViewController11_ScrollViewWithFullscreen

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = nil;

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;        
    }
    
    if (@available(iOS 13.0, *)) {
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)nx_barTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
