//
//  ViewController1_Test.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController1_Test.h"

@interface ViewController1_Test ()

@end

@implementation ViewController1_Test

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor blueColor];
}

@end
