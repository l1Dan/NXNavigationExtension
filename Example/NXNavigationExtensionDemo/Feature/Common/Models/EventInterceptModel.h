//
//  EventInterceptItem.h
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EventInterceptItemType) {
    EventInterceptItemTypeBoth,
    EventInterceptItemTypeBackButton,
    EventInterceptItemTypePopGesture
};

@interface EventInterceptModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) EventInterceptItemType itemType;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType;

+ (instancetype)itemWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType;

+ (NSArray<EventInterceptModel *> *)makeAllModels;

@end

NS_ASSUME_NONNULL_END
