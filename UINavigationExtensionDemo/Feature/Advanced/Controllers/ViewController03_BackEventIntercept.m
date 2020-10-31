//
//  ViewController03_BackEventIntercept.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController03_BackEventIntercept.h"
#import "EventInterceptModel.h"


@interface ViewController03_BackEventIntercept () <UINavigationControllerCustomizable>

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

#pragma mark - Private

- (void)showAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否继续返回？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

#pragma mark - Getter

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

#pragma mark - UINavigationControllerCustomizable

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willPopViewControllerUsingInteractiveGesture:(BOOL)usingGesture {
    if (self.currentItemType == EventInterceptItemTypeBoth) {
        [self showAlertController];
        return NO;
    }
    
    if (self.currentItemType == EventInterceptItemTypeBackButton) {
        if (!usingGesture) {
            [self showAlertController];
            return NO;
        }
    }
    
    if (self.currentItemType == EventInterceptItemTypePopGesture) {
        if (usingGesture) {
            [self showAlertController];
            return NO;
        }
    }
    
    return YES;
}

@end
