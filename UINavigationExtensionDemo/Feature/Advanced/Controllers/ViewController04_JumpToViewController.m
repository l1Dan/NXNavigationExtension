//
//  ViewController04_JumpToViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController04_JumpToViewController.h"

@interface ViewController04_JumpToViewController ()

@end

@implementation ViewController04_JumpToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor whiteColor];
}

@end
