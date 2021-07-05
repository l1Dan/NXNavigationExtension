//
//  UITableViewCell+Enabled.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import "UITableViewCell+Enabled.h"

@implementation UITableViewCell (Enabled)

- (void)setCellClickEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.alpha = enabled ? 1.0 : 0.5;
    for (__kindof UIView *view in self.subviews) {
        view.userInteractionEnabled = enabled;
        view.alpha = enabled ? 1.0 : 0.5;
    }
}

@end
