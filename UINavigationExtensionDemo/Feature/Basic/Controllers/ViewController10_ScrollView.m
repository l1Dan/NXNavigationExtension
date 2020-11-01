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

@property (nonatomic, strong) UIColor *randomColor;

@end

@implementation ViewController10_ScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.randomColor = [UIColor randomColor];
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
    cell.textLabel.textColor = [UIColor customDarkGrayColor];
    cell.contentView.backgroundColor = self.randomColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[RandomColorViewController alloc] init] animated:YES];
}

@end
