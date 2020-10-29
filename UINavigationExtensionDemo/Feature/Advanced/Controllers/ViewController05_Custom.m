//
//  ViewController05_Custom.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
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

@end

@implementation ViewController05_Custom

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.ue_navigationBar addContainerSubview:self.searchTextField];
    [self.ue_navigationBar addContainerSubview:self.backButton];
    [self.ue_navigationBar addContainerSubview:self.addButton];
}

- (UIColor *)ue_barTintColor {
    return [UIColor clearColor];
}

- (UIImage *)ue_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgorundImage;
}

// 点击导航栏控件事件可以由 ContainerView 响应
- (BOOL)ue_enableContainerViewFeature {
    return YES;
}

#pragma mark - Getter

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        CGRect rect = self.ue_navigationBar.containerView.frame;
        UIImage *image = [[UIImage imageNamed:@"NavigationBarSearch"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tintColor = [UIColor customDarkGrayColor];
        [imageView sizeToFit];
        
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(44 + 8, 2, rect.size.width - (44 + 8) * 2, 40)];
        _searchTextField.layer.cornerRadius = 20;
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
        _backButton.frame = CGRectMake(0, 2, 44, 40);
        _backButton.backgroundColor = [UIColor greenColor];
        [_backButton setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self.navigationController action:@selector(ue_triggerSystemBackButtonHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        CGRect rect = self.ue_navigationBar.containerView.frame;
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(rect.size.width - 44, 2, 44, 40);
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
