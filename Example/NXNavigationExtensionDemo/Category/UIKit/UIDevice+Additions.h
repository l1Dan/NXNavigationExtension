//
//  UIDevice+Additions.h
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Additions)

@property (nonatomic, assign, readonly, class, getter=isPhoneDevice) BOOL phoneDevice;

@end

NS_ASSUME_NONNULL_END
