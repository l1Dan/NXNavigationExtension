//
//  ViewController10_FullScreen.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController10_FullScreen.h"
#import "UIColor+RandomColor.h"

@interface ViewController10_FullScreen ()

@property (nonatomic, strong) UIColor *randomColor;

@end

@implementation ViewController10_FullScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.randomColor;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)ue_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return self.randomColor;
}

#pragma mark - Getter

- (UIColor *)randomColor {
    if (!_randomColor) {
        _randomColor = [UIColor randomColor];
    }
    return _randomColor;
}


@end
