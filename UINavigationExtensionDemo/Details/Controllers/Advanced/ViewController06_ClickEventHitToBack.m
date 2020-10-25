//
//  ViewController06_ClickEventHitToBack.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import "ViewController06_ClickEventHitToBack.h"

@interface ViewController06_ClickEventHitToBack ()

@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation ViewController06_ClickEventHitToBack

- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGFloat maxHeight = CGRectGetHeight(self.ue_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.navigationItem.title = nil;
}

- (BOOL)ue_hidesNavigationBar {
    return YES;
}

#pragma mark - Getter

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        CGRect rect = self.ue_navigationBar.frame;
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"First", @"Second"]];
        segmentedControl.frame = self.navigationController.navigationBar.frame;
        segmentedControl.tintColor = [UIColor redColor];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(changeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        [_tableHeaderView addSubview:segmentedControl];
    }
    return _tableHeaderView;
}

- (void)changeSegmentedControl:(UISegmentedControl *)segmentedControl {
    NSLog(@"%@", [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
}

@end
