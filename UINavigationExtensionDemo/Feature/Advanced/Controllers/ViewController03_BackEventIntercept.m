//
//  ViewController03_BackEventIntercept.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController03_BackEventIntercept.h"

typedef NS_ENUM(NSUInteger, EventInterceptItemType) {
    EventInterceptItemTypeBoth,
    EventInterceptItemTypeBackButton,
    EventInterceptItemTypePopGesture
};

@interface EventInterceptItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) EventInterceptItemType itemType;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

@implementation EventInterceptItem

- (instancetype)initWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType {
    if (self = [super init]) {
        _title = title;
        _itemType = itemType;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title itemType:(EventInterceptItemType)itemType {
    return [[self alloc] initWithTitle:title itemType:itemType];
}

+ (NSArray<EventInterceptItem*> *)allItems {
    EventInterceptItem *interceptBoth = [EventInterceptItem itemWithTitle:@"拦截手势滑动&点击返回按钮事件" itemType:EventInterceptItemTypeBoth];
    interceptBoth.selected = YES;
    
    EventInterceptItem *interceptPopGesture = [EventInterceptItem itemWithTitle:@"拦截手势滑动事件" itemType:EventInterceptItemTypePopGesture];
    EventInterceptItem *interceptBackEvent = [EventInterceptItem itemWithTitle:@"拦截返回按钮事件" itemType:EventInterceptItemTypeBackButton];
    return @[interceptBoth, interceptPopGesture, interceptBackEvent];
}

@end



@interface ViewController03_BackEventIntercept () <UINavigationControllerCustomizable>

@property (nonatomic, strong) NSArray<EventInterceptItem *> *allItems;
@property (nonatomic, assign) EventInterceptItemType currentItemType;

@end

@implementation ViewController03_BackEventIntercept

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (NSArray<EventInterceptItem *> *)allItems {
    if (!_allItems) {
        _allItems = [EventInterceptItem allItems];
    }
    return _allItems;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    EventInterceptItem *item = self.allItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = item.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    if (item.isSelected) {
        self.currentItemType = item.itemType;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (EventInterceptItem *item in self.allItems) {
        item.selected = NO;
    }
    
    self.allItems[indexPath.row].selected = YES;
    [tableView reloadData];
}

#pragma mark - UINavigationControllerCustomizable

- (BOOL)navigationController:(__kindof UINavigationController *)navigationController willJumpToViewControllerUsingInteractivePopGesture:(BOOL)usingGesture {
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
