//
//  ViewController06_ClickEventHitToBack.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/26.
//

#import <UINavigationExtension/UINavigationExtension.h>

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
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.tableHeaderView addSubview:self.segmentedControl];
    
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl.bottomAnchor constraintEqualToAnchor:self.tableHeaderView.bottomAnchor].active = YES;
    
    self.leftConstraint = [self.segmentedControl.leftAnchor constraintEqualToAnchor:self.tableHeaderView.leftAnchor];
    self.leftConstraint.active = YES;
    
    self.rightConstraint = [self.segmentedControl.rightAnchor constraintEqualToAnchor:self.tableHeaderView.rightAnchor];
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
    
    UIEdgeInsets safeAreaInsets = self.navigationController.navigationBar.safeAreaInsets;
    self.heightConstraint.constant = navigationBarFrame.size.height;
    self.leftConstraint.constant = safeAreaInsets.left;
    self.rightConstraint.constant = -safeAreaInsets.right;
}

- (BOOL)ue_hidesNavigationBar {
    return YES;
}

- (BOOL)ue_enableFullScreenInteractivePopGesture {
    return YES;
}

#pragma mark - Getter

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableHeaderView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"First", @"Second"]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customDarkGrayColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor customLightGrayColor]} forState:UIControlStateSelected];
        _segmentedControl.backgroundColor = [UIColor customLightGrayColor];
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
