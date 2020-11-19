//
//  ViewController10_ScrollView.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController10_ScrollView.h"
#import "RandomColorViewController.h"

#import "UIColor+RandomColor.h"

@interface ViewController10_ScrollView ()


@end

@implementation ViewController10_ScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (UIColor *)ue_shadowImageTintColor {
    return [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor lightGrayColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [[UIColor lightGrayColor] colorWithAlphaComponent:0.65];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %zd with UIScrollView", indexPath.row];
    cell.textLabel.textColor = [UIColor customTextColor];
    cell.contentView.backgroundColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
        return [UIColor randomLightColor];
    } darkModeColor:^UIColor * _Nonnull{
        return [UIColor randomDarkColor];
    }];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[RandomColorViewController alloc] init] animated:YES];
}

@end
