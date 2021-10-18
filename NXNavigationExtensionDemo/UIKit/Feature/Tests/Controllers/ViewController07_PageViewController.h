//
//  ViewController07_PageViewController.h
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/8.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController07_PageViewController : BaseViewController

@property (nonatomic, strong, readonly) NSArray<NSString *> *imageNames;

- (instancetype)initWithImageNames:(NSArray<NSString *> *)imageNames;

@end

NS_ASSUME_NONNULL_END
