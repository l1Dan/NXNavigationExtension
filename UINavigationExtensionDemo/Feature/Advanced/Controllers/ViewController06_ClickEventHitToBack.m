//
//  ViewController06_ClickEventHitToBack.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController06_ClickEventHitToBack.h"
#import "UIColor+RandomColor.h"

@interface ViewController06_ClickEventHitToBack ()

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign) CGFloat navigationBarHeight;

@end

@implementation ViewController06_ClickEventHitToBack

- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGFloat maxHeight = CGRectGetHeight(self.ue_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.navigationItem.title = nil;
    
    self.navigationBarHeight = CGRectGetHeight(self.ue_navigationBar.frame) - CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
}

- (BOOL)ue_hidesNavigationBar {
    return YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.navigationBarHeight = CGRectGetHeight(self.ue_navigationBar.frame) - CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    self.heightConstraint.constant = self.navigationBarHeight;
}

#pragma mark - Getter

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        CGRect rect = self.ue_navigationBar.frame;
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"First", @"Second"]];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customDarkGrayColor]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customLightGrayColor]} forState:UIControlStateSelected];
        segmentedControl.backgroundColor = [UIColor customLightGrayColor];
        if (@available(iOS 13.0, *)) {
            segmentedControl.selectedSegmentTintColor = [UIColor customDarkGrayColor];
        } else {
            segmentedControl.tintColor = [UIColor customDarkGrayColor];
        }
        
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(changeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        [_tableHeaderView addSubview:segmentedControl];
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        [segmentedControl.leftAnchor constraintEqualToAnchor:_tableHeaderView.leftAnchor].active = YES;
        [segmentedControl.bottomAnchor constraintEqualToAnchor:_tableHeaderView.bottomAnchor].active = YES;
        [segmentedControl.rightAnchor constraintEqualToAnchor:_tableHeaderView.rightAnchor].active = YES;
        
        _heightConstraint = [segmentedControl.heightAnchor constraintEqualToConstant:self.navigationBarHeight];
        _heightConstraint.active = YES;
    }
    return _tableHeaderView;
}

- (void)changeSegmentedControl:(UISegmentedControl *)segmentedControl {
    NSLog(@"%@", [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
}

@end
