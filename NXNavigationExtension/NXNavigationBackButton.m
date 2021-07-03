//
// NXNavigationBackButton.m
//
// Copyright (c) 2021 Leo Lee NXNavigationExtension (https://github.com/l1Dan/NXNavigationExtension)
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

#import "NXNavigationBackButton.h"
#import "NXNavigationExtensionMacro.h"
#import "NXNavigationExtensionPrivate.h"
#import "UINavigationController+NXNavigationExtension.h"

@interface NXNavigationBackButton ()

@property (nonatomic, weak) UIView *customView;
@property (nonatomic, weak) NSArray<__kindof UIViewController *> *viewControllers;

@end

@implementation NXNavigationBackButton

- (instancetype)initWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    return [self initWithCustomView:nil viewControllers:viewControllers];
}

- (instancetype)initWithCustomView:(UIView *)customView viewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    if (self = [super init]) {
        _customView = customView;
        _viewControllers = viewControllers;
        
        if (customView) {
            customView.userInteractionEnabled = NO;
            customView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:customView];
            [NSLayoutConstraint activateConstraints:@[
                [customView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [customView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [customView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                [customView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
            ]];
        }
        [self configurationMenu];
    }
    return self;
}

#pragma mark - Private

- (void)configurationMenu {
    if (!self.viewControllers || !self.viewControllers.count) {
        return;
    }
    
    if (@available(iOS 13.0, *)) {
        NSMutableArray<__kindof UIViewController *> *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        NSMutableArray<UIAction *> *actions = [NSMutableArray array];
        
        for (__kindof UIViewController *viewController in viewControllers.reverseObjectEnumerator) {
            NSString *title = viewController.navigationItem.title ?: @"";
            NSString *identifier = [NSString stringWithFormat:@"%zd", [viewControllers indexOfObject:viewController]];
            UIAction *action = [UIAction actionWithTitle:title image:nil identifier:identifier handler:^(__kindof UIAction * _Nonnull action) {
                NSUInteger index = [action.identifier integerValue];
                if (index < viewControllers.count) {
                    __kindof UIViewController *vc = viewControllers[index];
                    [vc.navigationController nx_popToViewController:vc animated:YES];
                }
            }];
            [actions addObject:action];
        }
                
        if (actions) {
            if (@available(iOS 14.0, *)) {
                self.contextMenuInteractionEnabled = actions.count;
                self.menu = [UIMenu menuWithChildren:actions];
            }
        }
    }
}

#pragma mark - UIContextMenuInteractionDelegate

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willDisplayMenuForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    UIWindow *window = NXNavigationExtensionGetKeyWindow();
    window.nx_showingBackButtonMenu = YES;
    [super contextMenuInteraction:interaction willDisplayMenuForConfiguration:configuration animator:animator];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willEndForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    UIWindow *window = NXNavigationExtensionGetKeyWindow();
    window.nx_showingBackButtonMenu = NO;
    [super contextMenuInteraction:interaction willEndForConfiguration:configuration animator:animator];
}

#pragma mark - Public

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self configurationMenu];
}

+ (NXNavigationBackButton *)buttonWithImage:(UIImage *)image viewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NXNavigationBackButton *button = [[NXNavigationBackButton alloc] initWithViewControllers:viewControllers];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

+ (NXNavigationBackButton *)buttonWithCustomView:(UIView *)customView viewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    return [[NXNavigationBackButton alloc] initWithCustomView:customView viewControllers:viewControllers];
}

@end
