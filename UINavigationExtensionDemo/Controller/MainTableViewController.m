//
//  MainTableViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/27.
//

#import "MainTableViewController.h"

#import "BlueViewController.h"
#import "BrownViewController.h"
#import "GrayViewController.h"
#import "OrangeViewController.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *allViewControllers;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.allViewControllers = @[
        @{@"className": NSStringFromClass([BlueViewController class]),  @"backgroundColor": [[UIColor blueColor] colorWithAlphaComponent:0.5]},
        @{@"className": NSStringFromClass([BrownViewController class]),  @"backgroundColor": [[UIColor brownColor] colorWithAlphaComponent:0.5]},
        @{@"className": NSStringFromClass([GrayViewController class]),  @"backgroundColor": [[UIColor grayColor] colorWithAlphaComponent:0.5]},
        @{@"className": NSStringFromClass([OrangeViewController class]),  @"backgroundColor": [[UIColor orangeColor] colorWithAlphaComponent:0.5]},
    ];
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor brownColor];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allViewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCellIdentifer"];
    NSDictionary *info = self.allViewControllers[indexPath.row];
    cell.textLabel.text = info[@"className"];
    cell.contentView.backgroundColor = info[@"backgroundColor"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = self.allViewControllers[indexPath.row];
    NSString *className = info[@"className"];
    UIViewController *viewController = (UIViewController *)[[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
