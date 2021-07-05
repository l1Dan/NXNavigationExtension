//
// NXNavigationMenuBackControl.m
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

#import "NXNavigationMenuBackControl.h"
#import "NXNavigationExtensionMacro.h"
#import "NXNavigationExtensionPrivate.h"
#import "UINavigationController+NXNavigationExtension.h"

@interface NXNavigationMenuBackControl () <UIContextMenuInteractionDelegate>

@property (nonatomic, strong) UIMenu *menu API_AVAILABLE(ios(13.0));
@property (nonatomic, strong) UIView *placeholderView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIColor *highlightedTintColor;

@property (nonatomic, weak) NSArray<__kindof UIViewController *> *viewControllers;

@end

@implementation NXNavigationMenuBackControl

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _customView = [[UIImageView alloc] initWithImage:image];
        [self addViewContents];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView {
    if (self = [super init]) {
        _customView = customView;
        [self addViewContents];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_customView) {
        [self.customView sizeToFit];
        CGRect customViewFrame = self.customView.bounds;
        CGFloat widtch = MAX(CGRectGetWidth(customViewFrame), CGRectGetWidth(self.frame));
        CGFloat height = MAX(MIN(CGRectGetHeight(customViewFrame), 0.0), CGRectGetHeight(self.frame));
        CGFloat y = (height - CGRectGetHeight(customViewFrame)) * 0.5;
        self.customView.frame = CGRectMake(0, y, CGRectGetWidth(customViewFrame), CGRectGetHeight(customViewFrame));
        
        CGRect frame = self.frame;
        frame.size = CGSizeMake(widtch, height);
        self.frame = frame;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (_customView) {
        _customView.tintColor = tintColor;
    }
    [super setTintColor:tintColor];
}

// UIControlStateHighlighted
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if (self.menuTintColor && !CGColorEqualToColor(self.menuTintColor.CGColor, [UIColor clearColor].CGColor)) {
        self.tintColor = self.highlightedTintColor;
    }
    [super touchesBegan:touches withEvent:event];
}

// UIControlStateNormal
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    self.tintColor = self.menuTintColor;
    [super touchesEnded:touches withEvent:event];
}

// UIControlStateNormal
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    self.tintColor = self.menuTintColor;
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - Private

- (void)addViewContents {
    self.highlightedTintColor = [UIColor grayColor];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.placeholderView];
    if (_customView) {
        self.customView.contentMode = UIViewContentModeScaleAspectFill;
        self.customView.userInteractionEnabled = NO;
        [self addSubview:self.customView];
    }
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self configurationMenu];
}


- (void)configurationMenu {
    if (!self.viewControllers || !self.viewControllers.count) { return; }
    
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

#pragma mark - Getter & Setter

- (UIView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, 1.0)];
        _placeholderView.backgroundColor = [UIColor clearColor];
    }
    return _placeholderView;
}

#pragma mark - UIContextMenuInteractionDelegate

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return self.menu;
    }];
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForHighlightingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    UIPreviewTarget *previewTarget = [[UIPreviewTarget alloc] initWithContainer:self.placeholderView center:CGPointZero];
    UIPreviewParameters *previewParameters = [[UIPreviewParameters alloc] init];
    previewParameters.backgroundColor = [UIColor clearColor];
    return [[UITargetedPreview alloc] initWithView:self.placeholderView parameters:previewParameters target:previewTarget];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willDisplayMenuForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    UIWindow *keyWindow = NXNavigationExtensionGetKeyWindow();
    keyWindow.nx_showingBackButtonMenu = YES;
    [super contextMenuInteraction:interaction willDisplayMenuForConfiguration:configuration animator:animator];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willEndForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    UIWindow *keyWindow = NXNavigationExtensionGetKeyWindow();
    keyWindow.nx_showingBackButtonMenu = YES;
    [super contextMenuInteraction:interaction willEndForConfiguration:configuration animator:animator];
}

@end
