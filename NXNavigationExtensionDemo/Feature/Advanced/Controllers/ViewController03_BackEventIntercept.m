//
//  ViewController03_BackEventIntercept.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController03_BackEventIntercept.h"
#import "EventInterceptModel.h"
#import "UIColor+RandomColor.h"

static CGFloat HeightForFooterInSection = 60.0;

@interface ViewController03_BackEventIntercept () <NXNavigationInteractable>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSArray<EventInterceptModel *> *allModels;
@property (nonatomic, assign) EventInterceptItemType currentItemType;

@end

@implementation ViewController03_BackEventIntercept

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor lightGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
    }];
}

- (BOOL)nx_backButtonMenuEnabled {
    return YES;
}

#pragma mark - Private

- (void)showAlertControllerWithViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续返回？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToViewController:viewController animated:YES];
    }]];

    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)clickPopViewControllerButton:(UIButton *)button {
    [self.navigationController nx_popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (UIView *)footerView {
    if (!_footerView) {
        CGFloat height = HeightForFooterInSection;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [[UIButton alloc] init];
        button.layer.borderColor = [UIColor purpleColor].CGColor;
        button.layer.borderWidth = 2.0;
        button.layer.cornerRadius = 10;
        button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:@"调用 “nx_pop” 方法返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor randomLightColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickPopViewControllerButton:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        
        [NSLayoutConstraint activateConstraints:@[
            [button.centerXAnchor constraintEqualToAnchor:_footerView.centerXAnchor],
            [button.centerYAnchor constraintEqualToAnchor:_footerView.centerYAnchor],
            [button.widthAnchor constraintEqualToAnchor:_footerView.widthAnchor multiplier:0.8],
            [button.heightAnchor constraintEqualToAnchor:_footerView.heightAnchor multiplier:0.8],
        ]];
        
    }
    return _footerView;
}

- (NSArray<EventInterceptModel *> *)allModels {
    if (!_allModels) {
        _allModels = [EventInterceptModel makeAllModels];
    }
    return _allModels;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    EventInterceptModel *item = self.allModels[indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = item.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    if (@available(iOS 13.0, *)) {
        cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    } else {
        cell.backgroundColor = [UIColor customGroupedBackgroundColor];
    }
    
    if (item.isSelected) {
        self.currentItemType = item.itemType;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (EventInterceptModel *item in self.allModels) {
        item.selected = NO;
    }
    
    self.allModels[indexPath.row].selected = YES;
    [tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HeightForFooterInSection;
}

#pragma mark - NXNavigationInteractable

- (BOOL)nx_navigationController:(__kindof UINavigationController *)navigationController willPopViewController:(__kindof UIViewController *)viewController interactiveType:(NXNavigationInteractiveType)interactiveType {
    NSLog(@"interactiveType: %zd %@", interactiveType, viewController);
    
    if (self.currentItemType == EventInterceptItemTypeBackButtonAction && interactiveType == NXNavigationInteractiveTypeBackButtonAction) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypeBackButtonMenuAction && interactiveType == NXNavigationInteractiveTypeBackButtonMenuAction) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypePopGestureRecognizer && interactiveType == NXNavigationInteractiveTypePopGestureRecognizer) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypeCallNXPopMethod && interactiveType == NXNavigationInteractiveTypeCallNXPopMethod) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypeAll) {
        [self showAlertControllerWithViewController:viewController];
        return NO;
    }
    
    return YES;
}

@end
