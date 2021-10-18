//
//  EventInterceptItem.m
//  NXNavigationExtensionDemo
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
    EventInterceptModel *interceptAll = [EventInterceptModel itemWithTitle:@"拦截所有返回页面途径" itemType:EventInterceptItemTypeAll];
    interceptAll.selected = YES;
    
    EventInterceptModel *interceptBackEvent = [EventInterceptModel itemWithTitle:@"拦截返回按钮点击事件" itemType:EventInterceptItemTypeBackButtonAction];
    EventInterceptModel *interceptBackMenuEvent = [EventInterceptModel itemWithTitle:@"拦截返回按钮长按选择事件" itemType:EventInterceptItemTypeBackButtonMenuAction];
    EventInterceptModel *interceptPopGesture = [EventInterceptModel itemWithTitle:@"拦截手势滑动返回事件" itemType:EventInterceptItemTypePopGestureRecognizer];
    EventInterceptModel *interceptNXPopMethod = [EventInterceptModel itemWithTitle:@"拦截调用 nx_pop 方法返回事件" itemType:EventInterceptItemTypeCallNXPopMethod];
    return @[interceptAll, interceptBackEvent, interceptBackMenuEvent, interceptPopGesture, interceptNXPopMethod];
}

@end
