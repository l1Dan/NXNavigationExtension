//
//  ViewController01_DisablePopGesture.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController01_DisablePopGesture.h"

@interface ViewController01_DisablePopGesture ()

@end

@implementation ViewController01_DisablePopGesture

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)nx_disableInteractivePopGesture {
    return YES;
}

@end
