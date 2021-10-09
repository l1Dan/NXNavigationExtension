//
//  ViewController06_ClickEventHitToBack.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController06_ClickEventHitToBack.h"
#import "UIColor+RandomColor.h"

@interface ViewController06_ClickEventHitToBack ()

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation ViewController06_ClickEventHitToBack

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableHeaderView addSubview:self.segmentedControl];
    
    [self.segmentedControl.bottomAnchor constraintEqualToAnchor:self.tableHeaderView.bottomAnchor constant:-4].active = YES;
    
    self.leftConstraint = [self.segmentedControl.leftAnchor constraintEqualToAnchor:self.tableHeaderView.leftAnchor];
    self.leftConstraint.active = YES;
    
    self.rightConstraint = [self.segmentedControl.rightAnchor constraintEqualToAnchor:self.tableHeaderView.rightAnchor];
    self.rightConstraint.priority = UILayoutPriorityDefaultHigh;
    self.rightConstraint.active = YES;
    
    self.heightConstraint = [self.segmentedControl.heightAnchor constraintEqualToConstant:0];
    self.heightConstraint.active = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat tableHeaderViewX = navigationBarFrame.origin.x;
    CGFloat tableHeaderViewY = navigationBarFrame.origin.y;
    CGFloat tableHeaderViewWidth = navigationBarFrame.size.width;
    CGFloat tableHeaderViewHeight = tableHeaderViewY + navigationBarFrame.size.height;

    self.tableHeaderView.frame = CGRectMake(tableHeaderViewX, tableHeaderViewY, tableHeaderViewWidth, tableHeaderViewHeight);
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    UIEdgeInsets safeAreaInsets = self.navigationController.navigationBar.layoutMargins;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = self.navigationController.navigationBar.safeAreaInsets;
    }
    self.heightConstraint.constant = navigationBarFrame.size.height * 0.8;
    self.leftConstraint.constant = safeAreaInsets.left;
    self.rightConstraint.constant = -safeAreaInsets.right;
}

- (BOOL)nx_translucentNavigationBar {
    return YES;
}

- (BOOL)nx_enableFullscreenInteractivePopGesture {
    return YES;
}

#pragma mark - Getter

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableHeaderView.backgroundColor = [UIColor customGroupedBackgroundColor];
    }
    return _tableHeaderView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Tap1", @"Tap2"]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        _segmentedControl.backgroundColor = [UIColor customLightGrayColor];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customDarkGrayColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customLightGrayColor]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(changeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        if (@available(iOS 13.0, *)) {
            _segmentedControl.selectedSegmentTintColor = [UIColor customDarkGrayColor];
        } else {
            _segmentedControl.tintColor = [UIColor customDarkGrayColor];
        }
    }
    return _segmentedControl;
}

- (void)changeSegmentedControl:(UISegmentedControl *)segmentedControl {
    NSLog(@"%@", [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
}

@end
