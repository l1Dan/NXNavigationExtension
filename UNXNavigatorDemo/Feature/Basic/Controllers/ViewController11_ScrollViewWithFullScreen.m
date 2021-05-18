//
//  ViewController11_ScrollViewWithFullScreen.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UNXNavigator/UNXNavigator.h>

#import "ViewController11_ScrollViewWithFullScreen.h"

@interface ViewController11_ScrollViewWithFullScreen ()

@end

@implementation ViewController11_ScrollViewWithFullScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    
#if TARGET_OS_MACCATALYST
    CGFloat maxHeight = CGRectGetHeight(self.unx_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
#endif
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
#if !TARGET_OS_MACCATALYST
    CGFloat maxHeight = CGRectGetHeight(self.unx_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
#endif
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)unx_barTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)unx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)unx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
