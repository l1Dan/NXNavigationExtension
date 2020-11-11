//
//  ViewController05_Custom.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController05_Custom.h"
#import "ViewController12_Modal.h"
#import "UIImage+NavigationBar.h"
#import "UIColor+RandomColor.h"

@interface ViewController05_Custom ()

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;

@end

@implementation ViewController05_Custom

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.ue_navigationBar addContainerSubview:self.searchTextField];
    [self.ue_navigationBar addContainerSubview:self.backButton];
    [self.ue_navigationBar addContainerSubview:self.addButton];
    
    UIView *containerView = self.ue_navigationBar.containerView;
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.leftConstraint = [self.backButton.leftAnchor constraintEqualToAnchor:containerView.leftAnchor];
    self.leftConstraint.active = YES;
    
    [self.backButton.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:2.0].active = YES;
    [self.backButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-2.0].active = YES;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.backButton.widthAnchor constraintEqualToConstant:44].active = YES;
    } else {
        self.backButton.hidden = YES;
        [self.backButton.widthAnchor constraintEqualToConstant:0].active = YES;
    }
        
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchTextField.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:2.0].active = YES;
    [self.searchTextField.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-2.0].active = YES;
    [self.searchTextField.leftAnchor constraintEqualToAnchor:self.backButton.rightAnchor constant:8.0].active = YES;
    [self.searchTextField.rightAnchor constraintEqualToAnchor:self.addButton.leftAnchor constant:-8.0].active = YES;
        
    self.addButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightConstraint = [self.addButton.rightAnchor constraintEqualToAnchor:containerView.rightAnchor];
    self.rightConstraint.active = YES;
    
    [self.addButton.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:2.0].active = YES;
    [self.addButton.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:-2.0].active = YES;
    [self.addButton.widthAnchor constraintEqualToConstant:44].active = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.navigationController.navigationBar.safeAreaInsets;
    self.leftConstraint.constant = safeAreaInsets.left;
    self.rightConstraint.constant = -safeAreaInsets.right;
    self.searchTextField.layer.cornerRadius = CGRectGetHeight(self.ue_navigationBar.containerView.frame) * 0.5 - 2;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)ue_barTintColor {
    return [UIColor clearColor];
}

- (UIImage *)ue_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgorundImage;
}

// 点击导航栏控件事件可以由 ContainerView 响应
- (BOOL)ue_containerViewWithoutNavigtionBar {
    return YES;
}

#pragma mark - Getter

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        UIImage *image = [[UIImage imageNamed:@"NavigationBarSearch"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tintColor = [UIColor customDarkGrayColor];
        [imageView sizeToFit];
        
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = imageView;
        _searchTextField.tintColor = [UIColor customDarkGrayColor];
        _searchTextField.backgroundColor = [UIColor whiteColor];
    }
    return _searchTextField;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.backgroundColor = [UIColor greenColor];
        [_backButton setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self.navigationController action:@selector(ue_triggerSystemBackButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor orangeColor];
        [_addButton setImage:[UIImage imageNamed:@"NavigationBarAdd"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - Action
- (void)clickAddButton:(UIButton *)button {
    UINavigationController *controller = [[[self.navigationController class] alloc] initWithRootViewController:[[ViewController12_Modal alloc] init]];
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
