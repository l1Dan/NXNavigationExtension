//
// NXNavigationExtension+Deprecated.m
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

#import "NXNavigationExtension+Deprecated.h"

@implementation UINavigationController (NXNavigationExtensionDeprecated)

- (NSArray<UIViewController *> *)nx_rebuildStackWithViewControllerClass:(Class)aClass
                                                              isReverse:(BOOL)isReverse
                                                                  block:(__kindof UIViewController * (^__nullable)(void))block {
    NSMutableArray<__kindof UIViewController *> *tempViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    if (!aClass || (tempViewControllers.count <= 1)) return [NSArray arrayWithArray:tempViewControllers];
    
    // 当前界面显示的 ViewController
    __kindof UIViewController *topViewController = tempViewControllers.lastObject;
    // 排除当前界面显示的 ViewController
    [tempViewControllers removeLastObject];
    
    NSMutableArray<__kindof UIViewController *> *collections = [NSMutableArray array];
    NSArray<__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:tempViewControllers];
    if (isReverse) {
        collections = [NSMutableArray arrayWithArray:tempViewControllers];
        viewControllers = viewControllers.reverseObjectEnumerator.allObjects;
    }
    
    for (__kindof UIViewController *viewController in viewControllers) {
        // 添加
        if (!isReverse) [collections addObject:viewController];
        
        // 找到相同类型的 ViewController 就立即停止
        if ([NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass(aClass)]) {
            break;
        }
        // 没找到，已经到最后了
        if (viewController == viewControllers.lastObject && block) {
            __kindof UIViewController *appendsViewController = block();
            if (appendsViewController) {
                [collections addObject:appendsViewController];
                break;
            }
        }
        
        // 移除
        if (isReverse) [collections removeObject:viewController];
    }
    
    // 补上当前正在显示的 ViewController
    [collections addObject:topViewController];
    return [NSArray arrayWithArray:collections];
}

- (void)nx_setPreviousViewControllerWithClass:(Class)aClass
 insertsInstanceToBelowWhenNotFoundUsingBlock:(__kindof UIViewController * _Nullable (^)(void))block {
    NSArray<__kindof UIViewController *> *viewControllers = [self nx_rebuildStackWithViewControllerClass:aClass isReverse:NO block:block];
    [self setViewControllers:viewControllers animated:YES];
}

@end
