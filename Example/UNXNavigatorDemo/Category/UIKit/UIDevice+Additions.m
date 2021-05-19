//
//  UIDevice+Additions.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/11/14.
//

#import "UIDevice+Additions.h"

@implementation UIDevice (Additions)

+ (BOOL)isPhoneDevice {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

@end
