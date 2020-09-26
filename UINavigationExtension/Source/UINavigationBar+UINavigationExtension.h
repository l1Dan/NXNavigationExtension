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

/// 阻止事件被接受，需要事件穿透传递
@property (nonatomic, assign) BOOL ue_userInteractionDisabled;

@end

NS_ASSUME_NONNULL_END
