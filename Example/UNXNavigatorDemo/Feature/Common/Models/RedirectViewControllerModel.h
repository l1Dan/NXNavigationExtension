//
//  RedirectViewControllerModel.h
//  UNXNavigatorDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RedirectViewControllerType) {
    RedirectViewControllerTypeTest1,
    RedirectViewControllerTypeTest2,
    RedirectViewControllerTypeTest3,
    RedirectViewControllerTypeTest4,
    RedirectViewControllerTypeTest5,
    RedirectViewControllerTypeChoose,
    RedirectViewControllerTypeJump,
};

@interface RedirectViewControllerModel : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) RedirectViewControllerType type;
@property (nonatomic, assign, getter=isClickEnabled) BOOL clickEnabled;

- (instancetype)initWithTitle:(NSString *)title type:(RedirectViewControllerType)type;

+ (instancetype)modelWithTitle:(NSString *)title type:(RedirectViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
