//
// NXNavigationVirtualWrapperView.m
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
#import "NXNavigationExtensionPrivate.h"
#import "UIViewController+NXNavigationExtension.h"

@interface NXNavigationVirtualWrapperView ()

@property (nonatomic, weak) __kindof UIViewController *hostingController;

@end

@implementation NXNavigationVirtualWrapperView

- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController
          willPopViewController:(__kindof UIViewController *)viewController
                interactiveType:(NXNavigationInteractiveType)interactiveType {
    return YES;
}

+ (NXNavigationVirtualWrapperView *)filterNavigationVirtualWrapperViewWithViewController:(__kindof UIViewController *)hostingController {
    if (!hostingController || !hostingController.view) return nil;
    if (hostingController.nx_navigationVirtualWrapperView) return hostingController.nx_navigationVirtualWrapperView;
    
    UIView *view = hostingController.view;
    NSString *hostingViewClassName = NSStringFromClass([view class]);
    if (![hostingViewClassName containsString:@"SwiftUI"] || ![hostingViewClassName containsString:@"HostingView"]) {
        return nil;
    }
    
    NXNavigationVirtualWrapperView *virtualWrapperView = nil;
    for (UIView *wrapperView in view.subviews) {
        NSString *wrapperViewClassName = NSStringFromClass([wrapperView class]);
        if ([wrapperViewClassName containsString:@"ViewHost"] && [wrapperViewClassName containsString:@"NXNavigationWrapperView"]) {
            for (NXNavigationVirtualWrapperView *subview in wrapperView.subviews) {
                if ([subview isKindOfClass:[NXNavigationVirtualWrapperView class]]) {
                    virtualWrapperView = subview;
                    break;
                }
            }
        }
    }
    return virtualWrapperView;
}

@end
