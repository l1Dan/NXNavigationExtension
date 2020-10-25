//
//  FakeNavigationBar.h
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FakeNavigationItemType) {
    FakeNavigationItemTypeBackButton,
    FakeNavigationItemTypeAddButton
};

@class FakeNavigationBar;
@protocol FakeNavigationBarDelegate <NSObject>

- (void)fakeNavigationBar:(FakeNavigationBar *)navigationBar didClickNavigationItemwithItemType:(FakeNavigationItemType)itemType;

@end

@interface FakeNavigationBar : UIView

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, weak, nullable) id<FakeNavigationBarDelegate> delegate;

- (void)updateNavigationBarAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
