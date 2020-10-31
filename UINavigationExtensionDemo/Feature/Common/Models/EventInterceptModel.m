//
//  EventInterceptItem.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import "EventInterceptModel.h"

@implementation EventInterceptModel

- (instancetype)initWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType {
    if (self = [super init]) {
        _title = title;
        _itemType = itemType;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType {
    return [[self alloc] initWithTitle:title itemType:itemType];
}

+ (NSArray<EventInterceptModel*> *)makeAllModels {
    EventInterceptModel *interceptBoth = [EventInterceptModel itemWithTitle:@"拦截手势滑动&点击返回按钮事件" itemType:EventInterceptItemTypeBoth];
    interceptBoth.selected = YES;
    
    EventInterceptModel *interceptPopGesture = [EventInterceptModel itemWithTitle:@"拦截手势滑动事件" itemType:EventInterceptItemTypePopGesture];
    EventInterceptModel *interceptBackEvent = [EventInterceptModel itemWithTitle:@"拦截返回按钮事件" itemType:EventInterceptItemTypeBackButton];
    return @[interceptBoth, interceptPopGesture, interceptBackEvent];
}

@end
