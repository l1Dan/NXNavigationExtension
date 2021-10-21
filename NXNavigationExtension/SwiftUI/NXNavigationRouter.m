//
//  NXNavigationRouter.m
//  NXNavigationExtension
//
//  Created by lidan on 2021/10/21.
//

#import "NXNavigationRouter.h"
#import "UINavigationController+NXNavigationExtension.h"

@interface UINavigationController (NXNavigationExtensionPrivate)

@property (nonatomic, strong, readonly) NXNavigationRouter *nx_navigationRouter API_AVAILABLE(ios(13.0));

@end


@implementation NXNavigationContext

- (instancetype)initWithRouteName:(NSString *)routeName viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _routeName = routeName;
        _viewController = viewController;
    }
    return self;
}

@end


@interface NXNavigationRouter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NXNavigationContext *> *contextInfo;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, assign) BOOL callNXPopMethod;

@end

@implementation NXNavigationRouter

#pragma mark - Getter

- (NSMutableDictionary<NSString *,NXNavigationContext *> *)contextInfo {
    if (!_contextInfo) {
        _contextInfo = [NSMutableDictionary dictionary];
    }
    
    return _contextInfo;
}

- (NXNavigationRouter *)nx {
    self.callNXPopMethod = YES;
    return self;
}

#pragma mark - Private

- (NSString *)checkRouteName:(NSString *)routeName {
    if (!routeName) return nil;
    
    routeName = [routeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (routeName.length == 0) return nil;
    
    return routeName;
}

#pragma mark - Public

+ (instancetype)of:(NXNavigationContext *)context {
    NXNavigationRouter *navigationRouter = context.viewController.navigationController.nx_navigationRouter;
    navigationRouter.navigationController = context.viewController.navigationController;
    return navigationRouter;
}

- (void)addContext:(NXNavigationContext *)context {
    NSString *routeName = [self checkRouteName:context.routeName];
    if (!routeName) {
        NSLog(@"路由名字不规范");
        return;
    }
    
    self.contextInfo[routeName] = context;
}

- (void)removeContext:(NXNavigationContext *)context {
    NSString *routeName = [self checkRouteName:context.routeName];
    if (!routeName) return;
    
    [self.contextInfo removeObjectForKey:routeName];
}

- (void)popWithAnimated:(BOOL)animated {
    if (self.callNXPopMethod) {
        self.callNXPopMethod = NO;
        [self.navigationController nx_popViewControllerAnimated:animated];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)popWithRouteName:(NSString *)routeName animated:(BOOL)animated {
    if (!routeName) {
        self.callNXPopMethod = NO;
        return;
    }
    
    routeName = [self checkRouteName:routeName];
    if ([routeName isEqualToString:@""]) {
        [self popWithAnimated:animated];
        return;
    }
    
    if ([routeName isEqualToString:@"/"]) {
        if (self.callNXPopMethod) {
            self.callNXPopMethod = NO;
            [self.navigationController nx_popToRootViewControllerAnimated:animated];
        } else {
            [self.navigationController popToRootViewControllerAnimated:animated];
        }
    }
    
    NXNavigationContext *context = self.contextInfo[routeName];
    if (context && context.viewController) {
        if (self.callNXPopMethod) {
            self.callNXPopMethod = NO;
            [self.navigationController nx_popToViewController:context.viewController animated:animated];
        } else {
            [self.navigationController popToViewController:context.viewController animated:animated];
        }
    }
}

@end
