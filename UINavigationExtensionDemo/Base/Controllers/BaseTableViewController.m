//
//  BaseTableViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/22.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "BaseTableViewController.h"
#import "RandomColorViewController.h"
#import "UIColor+RandomColor.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %zd", indexPath.row];
    cell.textLabel.textColor = [UIColor customTextColor];
    cell.contentView.backgroundColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor randomLightColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor randomDarkColor];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[RandomColorViewController alloc] init] animated:YES];
}

@end
