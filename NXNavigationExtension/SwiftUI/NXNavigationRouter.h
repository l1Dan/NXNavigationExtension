//
//  NXNavigationRouter.h
//  NXNavigationExtension
//
//  Created by lidan on 2021/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0), tvos(13.0))
@interface NXNavigationContext : NSObject

@property (nonatomic, copy, readonly) NSString *routeName;

@property (nonatomic, weak, readonly) UIViewController *viewController;

- (instancetype)initWithRouteName:(NSString *)routeName viewController:(UIViewController *)viewController;

@end


API_AVAILABLE(ios(13.0), tvos(13.0))
@interface NXNavigationRouter : NSObject

@property (nonatomic, strong, readonly) NXNavigationRouter *nx;

+ (instancetype)of:(NXNavigationContext *)context;

- (void)addContext:(NXNavigationContext *)context;

- (void)removeContext:(NXNavigationContext *)context;

- (void)popWithAnimated:(BOOL)animated;

- (void)popWithRouteName:(NSString *)routeName animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
