//
//  JumpViewControllerModel.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/30.
//

#import "JumpViewControllerModel.h"

@implementation JumpViewControllerModel

- (instancetype)initWithTitle:(NSString *)title type:(JumpViewControllerType)type {
    if (self = [super init]) {
        _title = title;
        _type = type;
        _clickEnabled = YES;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title type:(JumpViewControllerType)type {
    return [[self alloc] initWithTitle:title type:type];
}


@end
