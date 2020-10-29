//
//  ViewController09_Modal.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController09_Modal.h"
#import "UIImage+NavigationBar.h"

@interface ViewController09_Modal ()

@end

@implementation ViewController09_Modal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 44, 40);
    closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton setImage:[UIImage imageNamed:@"NavigationBarClose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
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

- (UIImage *)ue_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgorundImage;
}

- (void)clickCloseButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
