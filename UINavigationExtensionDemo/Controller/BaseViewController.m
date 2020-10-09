//
//  BaseViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [UENavigationBar registerAppearance:[[UENavigationBarAppearance alloc] init] forNavigationControllerClass: [UINavigationController class]];
    
    [super viewDidLoad];
}


@end
