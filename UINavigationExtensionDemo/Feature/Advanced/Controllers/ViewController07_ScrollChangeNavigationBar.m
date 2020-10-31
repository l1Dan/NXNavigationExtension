//
//  ViewController07_ScrollChangeNavigationBar.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController07_ScrollChangeNavigationBar.h"
#import "FakeNavigationBar.h"
#import "ViewController12_Modal.h"

@interface ViewController07_ScrollChangeNavigationBar () <FakeNavigationBarDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *navigationBarTitle;
@property (nonatomic, strong) FakeNavigationBar *fakeNavigationBar;

@property (nonatomic, assign) UIStatusBarStyle barStyle;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;

@end

@implementation ViewController07_ScrollChangeNavigationBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat maxHeight = CGRectGetHeight(self.ue_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
    self.tableView.tableHeaderView = self.imageView;
    
    self.navigationBarTitle = self.navigationItem.title;
    self.fakeNavigationBar.title = self.navigationItem.title;
    self.navigationItem.title = nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 44, 44)];
    view.backgroundColor = [UIColor redColor];
    [self.ue_navigationBar addContainerSubview:self.fakeNavigationBar];
    
    self.ue_navigationBar.alpha = 0.0;
    self.barStyle = UIStatusBarStyleLightContent;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *containerView = self.ue_navigationBar.containerView;

    self.fakeNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.topConstraint = [self.fakeNavigationBar.topAnchor constraintEqualToAnchor:containerView.topAnchor];
    self.topConstraint.active = YES;
    
    self.leftConstraint = [self.fakeNavigationBar.leftAnchor constraintEqualToAnchor:containerView.leftAnchor];
    self.leftConstraint.active = YES;
    
    self.bottomConstraint = [self.fakeNavigationBar.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor];
    self.bottomConstraint.active = YES;
    
    self.rightConstraint = [self.fakeNavigationBar.rightAnchor constraintEqualToAnchor:containerView.rightAnchor];
    self.rightConstraint.active = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = self.navigationController.navigationBar.safeAreaInsets;
    self.topConstraint.constant = safeAreaInsets.top;
    self.leftConstraint.constant = safeAreaInsets.left;
    self.bottomConstraint.constant = safeAreaInsets.bottom;
    self.rightConstraint.constant = -safeAreaInsets.right;
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)ue_barTintColor {
    return [UIColor clearColor];
}

- (BOOL)ue_containerViewWithoutNavigtionBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    CGFloat imageViewHeight = CGRectGetHeight(self.imageView.frame);
    CGFloat navigationBarHeight = CGRectGetHeight(self.ue_navigationBar.frame);
    CGFloat alpha = MAX(0.0, MIN(1.0, (offsetY - imageViewHeight + navigationBarHeight) / CGRectGetHeight(self.ue_navigationBar.frame)));
    self.ue_navigationBar.alpha = alpha;
    
    if (@available(iOS 13.0, *)) {
        self.barStyle = alpha > 0.0 ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent;
    } else {
        self.barStyle = alpha > 0.0 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    [self.fakeNavigationBar updateNavigationBarAlpha:alpha];
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewHeader"]];
        [_imageView sizeToFit];
    }
    return _imageView;
}

- (FakeNavigationBar *)fakeNavigationBar {
    if (!_fakeNavigationBar) {
        _fakeNavigationBar = [[FakeNavigationBar alloc] initWithFrame:CGRectZero];
        _fakeNavigationBar.delegate = self;
    }
    return _fakeNavigationBar;
}

#pragma mark - FakeNavigationBarDelegate

- (void)fakeNavigationBar:(FakeNavigationBar *)navigationBar didClickNavigationItemwithItemType:(FakeNavigationItemType)itemType {
    switch (itemType) {
        case FakeNavigationItemTypeBackButton: {
            [self.navigationController ue_triggerSystemBackButtonHandler];
        } break;
        case FakeNavigationItemTypeAddButton: {
            UINavigationController *controller = [[[self.navigationController class] alloc] initWithRootViewController:[[ViewController12_Modal alloc] init]];
            [self presentViewController:controller animated:YES completion:NULL];
        } break;
    }
}

@end
