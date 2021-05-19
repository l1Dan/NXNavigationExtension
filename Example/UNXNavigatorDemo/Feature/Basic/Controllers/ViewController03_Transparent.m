//
//  ViewController03_Transparent.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UNXNavigator/UNXNavigator.h>

#import "ViewController03_Transparent.h"

@interface ViewController03_Transparent ()

@end

@implementation ViewController03_Transparent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIColor *)unx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)unx_shadowImageTintColor {
    return [UIColor clearColor];
}

@end
