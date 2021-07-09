//
//  ViewController07_ScrollChangeNavigationBar.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController07_ScrollChangeNavigationBar.h"
#import "FakeNavigationBar.h"
#import "ViewController12_Modal.h"

@interface ViewController07_ScrollChangeNavigationBar () <FakeNavigationBarDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) FakeNavigationBar *fakeNavigationBar;

@property (nonatomic, copy) NSString *navigationBarTitle;
@property (nonatomic, assign) UIStatusBarStyle barStyle;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;

@end

@implementation ViewController07_ScrollChangeNavigationBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.imageView;
    
    self.navigationBarTitle = self.navigationItem.title;
    self.fakeNavigationBar.title = self.navigationItem.title;
    self.navigationItem.title = nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 44, 44)];
    view.backgroundColor = [UIColor redColor];
    [self.nx_navigationBar addContainerViewSubview:self.fakeNavigationBar];
    
    self.nx_navigationBar.alpha = 0.0;
    self.barStyle = UIStatusBarStyleLightContent;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *containerView = self.nx_navigationBar.containerView;

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
    
    CGFloat maxHeight = CGRectGetHeight(self.nx_navigationBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(-maxHeight, 0, 0, 0);
    
    UIEdgeInsets safeAreaInsets = self.navigationController.navigationBar.layoutMargins;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = self.navigationController.navigationBar.safeAreaInsets;
    }
    self.topConstraint.constant = safeAreaInsets.top;
    self.leftConstraint.constant = safeAreaInsets.left;
    self.bottomConstraint.constant = safeAreaInsets.bottom;
    self.rightConstraint.constant = -safeAreaInsets.right;
}

- (UIColor *)nx_barTintColor {
    return [UIColor clearColor];
}

- (BOOL)nx_containerViewWithoutNavigtionBar {
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
    CGFloat navigationBarHeight = CGRectGetHeight(self.nx_navigationBar.frame);
    CGFloat alpha = MAX(0.0, MIN(1.0, (offsetY - imageViewHeight + navigationBarHeight) / CGRectGetHeight(self.nx_navigationBar.frame)));
    self.nx_navigationBar.alpha = alpha;
    
    if (@available(iOS 13.0, *)) {
        if (self.view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.barStyle = UIStatusBarStyleLightContent;
        } else {
            self.barStyle = alpha > 0.0 ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent;
        }
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
        _fakeNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        _fakeNavigationBar.delegate = self;
    }
    return _fakeNavigationBar;
}

#pragma mark - FakeNavigationBarDelegate

- (void)fakeNavigationBar:(FakeNavigationBar *)navigationBar didClickNavigationItemWithItemType:(FakeNavigationItemType)itemType {
    switch (itemType) {
        case FakeNavigationItemTypeBackButton: {
            [self.navigationController nx_popViewControllerAnimated:YES];
        } break;
        case FakeNavigationItemTypeAddButton: {
            UINavigationController *controller = [[[self.navigationController class] alloc] initWithRootViewController:[[ViewController12_Modal alloc] init]];
            [self presentViewController:controller animated:YES completion:NULL];
        } break;
    }
}

@end
