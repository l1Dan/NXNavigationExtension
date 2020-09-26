//
//  UIBarButtonItem+Convenience.h
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIBarButtonItem (Convenience)

+ (instancetype)itemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;

@end
NS_ASSUME_NONNULL_END
