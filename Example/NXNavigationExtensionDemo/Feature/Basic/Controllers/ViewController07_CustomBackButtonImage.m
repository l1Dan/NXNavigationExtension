//
//  ViewController07_CustomBackButtonImage.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController07_CustomBackButtonImage.h"

@interface ViewController07_CustomBackButtonImage ()

@end

@implementation ViewController07_CustomBackButtonImage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIImage *)nx_backImage {
    return [UIImage imageNamed:@"NavigationBarBack"];
}

@end
