//
//  UIBarButtonItem+Convenience.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import "UIBarButtonItem+Convenience.h"

@implementation UIBarButtonItem (Convenience)

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

@end
