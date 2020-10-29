//
//  ViewController01_DisablePopGesture.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController01_DisablePopGesture.h"

@interface ViewController01_DisablePopGesture ()

@end

@implementation ViewController01_DisablePopGesture

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)ue_disableInteractivePopGesture {
    return YES;
}

@end
