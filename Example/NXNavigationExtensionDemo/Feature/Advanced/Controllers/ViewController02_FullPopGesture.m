//
//  ViewController02_FullPopGesture.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController02_FullPopGesture.h"

@interface ViewController02_FullPopGesture ()

@end

@implementation ViewController02_FullPopGesture

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)nx_enableFullScreenInteractivePopGesture {
    return YES;
}

@end
