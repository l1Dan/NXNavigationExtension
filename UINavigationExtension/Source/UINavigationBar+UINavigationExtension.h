//
//  UINavigationBar+UINavigationExtension.h
//  UINavigationExtension
//
//  Created by lidan on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UINavigationBarDidUpdateFrameHandler)(CGRect frame);

@interface UINavigationBar (UINavigationExtension)

@property (nonatomic, copy, nullable) UINavigationBarDidUpdateFrameHandler ue_didUpdateFrameHandler;

@end

NS_ASSUME_NONNULL_END
