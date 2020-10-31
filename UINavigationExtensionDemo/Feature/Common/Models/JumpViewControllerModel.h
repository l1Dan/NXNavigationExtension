//
//  JumpViewControllerModel.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JumpViewControllerType) {
    JumpViewControllerTypeTest1,
    JumpViewControllerTypeTest2,
    JumpViewControllerTypeTest3,
    JumpViewControllerTypeTest4,
    JumpViewControllerTypeTest5,
    JumpViewControllerTypeChoose,
    JumpViewControllerTypeJump,
};

@interface JumpViewControllerModel : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) JumpViewControllerType type;
@property (nonatomic, assign, getter=isClickEnabled) BOOL clickEnabled;

- (instancetype)initWithTitle:(NSString *)title type:(JumpViewControllerType)type;

+ (instancetype)modelWithTitle:(NSString *)title type:(JumpViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
