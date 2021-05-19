//
//  RedirectViewControllerModel.m
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import "RedirectViewControllerModel.h"

@implementation RedirectViewControllerModel

- (instancetype)initWithTitle:(NSString *)title type:(RedirectViewControllerType)type {
    if (self = [super init]) {
        _title = title;
        _type = type;
        _clickEnabled = YES;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title type:(RedirectViewControllerType)type {
    return [[self alloc] initWithTitle:title type:type];
}


@end
