//
//  ViewController04_Translucent.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController04_Translucent.h"
#import "UIColor+RandomColor.h"

@interface ViewController04_Translucent ()

@end

@implementation ViewController04_Translucent

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)ue_useSystemBlurNavigationBar {
    return YES;
}

- (UIColor *)randomColor {
    return [UIColor randomColor];
}

@end