//
// NXNavigationRouter.m
//
// Copyright (c) 2020 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NXNavigationVirtualWrapperView.h"

#import "NXNavigationExtensionInternal.h"
#import "NXNavigationRouter.h"

#import "UINavigationController+NXNavigationExtension.h"
#import "UIViewController+NXNavigationExtension.h"


@implementation NXNavigationRouterContext

- (instancetype)initWithRouteName:(NSString *)routeName {
    if (self = [super init]) {
        _routeName = routeName ?: @"";
    }
    return self;
}

+ (instancetype)navigationRouterContextWithRouteName:(NSString *)routeName {
    return [[[self class] alloc] initWithRouteName:routeName];
}

@end


@interface NXNavigationRouter ()

@property (nonatomic, weak) NXNavigationRouterContext *context;
@property (nonatomic, assign) BOOL callNXPopMethod;

@end


@implementation NXNavigationRouter

#pragma mark - Getter

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

- (BOOL)popWithAnimated:(BOOL)animated {
    UINavigationController *navigationController = self.context.hostingController.navigationController;
    if (!navigationController) {
        return NO;
    }
    
    if (self.callNXPopMethod) {
        self.callNXPopMethod = NO;
        return [navigationController nx_popViewControllerAnimated:animated] ? YES : NO;
    } else {
        return [navigationController popViewControllerAnimated:animated] ? YES : NO;
    }
    return NO;
}

#pragma mark - Public

+ (instancetype)of:(NXNavigationRouterContext *)context {
    NXNavigationRouter *navigationRouter = context.hostingController.navigationController.nx_navigationRouter;
    navigationRouter.context = context;
    return navigationRouter;
}

- (NSArray<__kindof UIViewController *> *)filterViewControllersWithRouteName:(NSString *)routeName {
    if (!routeName ||
        !self.context ||
        !self.context.hostingController ||
        !self.context.hostingController.navigationController ||
        !self.context.hostingController.navigationController.viewControllers) {
        return @[];
    }
    
    NSArray<__kindof UIViewController *> *viewControllers = self.context.hostingController.navigationController.viewControllers;
    NSMutableArray<__kindof UIViewController *> *filterViewControllers = [NSMutableArray array];
    for (__kindof UIViewController *viewController in viewControllers) {
        if (viewController.nx_navigationVirtualWrapperView &&
            viewController.nx_navigationVirtualWrapperView.context &&
            viewController.nx_navigationVirtualWrapperView.context.routeName &&
            [viewController.nx_navigationVirtualWrapperView.context.routeName isEqualToString:routeName]) {
            if (self.context.hostingController != viewController) {
                [filterViewControllers addObject:viewController];
            }
        }
    }
    return filterViewControllers;
}

- (void)setNeedsNavigationBarAppearanceUpdate {
    __kindof UIViewController *hostingController = self.context.hostingController;
    if (!hostingController) return;
    
    NXNavigationVirtualWrapperView *view = hostingController.nx_navigationVirtualWrapperView;
    if (view && view.prepareConfigurationCallback && hostingController.nx_configuration) {
        view.prepareConfigurationCallback(hostingController, hostingController.nx_configuration);
        [hostingController nx_setNeedsNavigationBarAppearanceUpdate];
    }
}

- (BOOL)popToFirst:(BOOL)first routeName:(NSString *)routeName animated:(BOOL)animated {
    if (!self.context ||
        !self.context.routeName ||
        !self.context.routeName.length) {
        return NO;
    }
    
    routeName = [self checkRouteName:routeName];
    if (!routeName || [routeName isEqualToString:@""]) {
        return [self popWithAnimated:animated];
    }
    
    UINavigationController *navigationController = self.context.hostingController.navigationController;
    if (!navigationController) {
        return NO;
    }
    
    if ([routeName isEqualToString:@"/"]) {
        if (self.callNXPopMethod) {
            self.callNXPopMethod = NO;
            return [navigationController nx_popToRootViewControllerAnimated:animated] ? YES : NO;
        } else {
            return [navigationController popToRootViewControllerAnimated:animated] ? YES : NO;
        }
    }
    
    NSArray<__kindof UIViewController *> *viewControllers = [self filterViewControllersWithRouteName:routeName];
    if (viewControllers && viewControllers.count) {
        __kindof UIViewController *viewController = first ? viewControllers.firstObject : viewControllers.lastObject;
        if (self.callNXPopMethod) {
            self.callNXPopMethod = NO;
            return [navigationController nx_popToViewController:viewController animated:animated] ? YES : NO;
        } else {
            return [navigationController popToViewController:viewController animated:animated] ? YES : NO;
        }
    }
    
    return NO;
}

@end
