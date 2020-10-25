//
//  ViewController05_Custom.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import "LightNavigationController.h"
#import "ViewController05_Custom.h"
#import "ViewController09_Modal.h"

#import "UIImage+NavigationBar.h"

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
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(44 + 8, 0, rect.size.width - (44 + 8) * 2, 44)];
        _searchTextField.layer.cornerRadius = 22;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBarSearch"]];
        _searchTextField.backgroundColor = [UIColor customLightGrayColor];
    }
    return _searchTextField;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
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
        _addButton.frame = CGRectMake(rect.size.width - 44, 0, 44, 44);
        _addButton.backgroundColor = [UIColor orangeColor];
        [_addButton setImage:[UIImage imageNamed:@"NavigationBarAdd"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - Action
- (void)clickAddButton:(UIButton *)button {
    LightNavigationController *controller = [[LightNavigationController alloc] initWithRootViewController:[[ViewController09_Modal alloc] init]];
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
