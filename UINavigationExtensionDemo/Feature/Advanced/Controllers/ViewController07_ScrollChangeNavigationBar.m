//
//  ViewController07_ScrollChangeNavigationBar.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
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
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)ue_barTintColor {
    return [UIColor clearColor];
}

- (BOOL)ue_enableContainerViewFeature {
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
        _fakeNavigationBar = [[FakeNavigationBar alloc] initWithFrame:self.ue_navigationBar.containerView.bounds];
        _fakeNavigationBar.delegate = self;
    }
    return _fakeNavigationBar;
}

#pragma mark - FakeNavigationBarDelegate

- (void)fakeNavigationBar:(FakeNavigationBar *)navigationBar didClickNavigationItemwithItemType:(FakeNavigationItemType)itemType {
    switch (itemType) {
        case FakeNavigationItemTypeBackButton: {
            [self.navigationController ue_triggerSystemBackButtonHandle];
        } break;
        case FakeNavigationItemTypeAddButton: {
            UINavigationController *controller = [[[self.navigationController class] alloc] initWithRootViewController:[[ViewController12_Modal alloc] init]];
            [self presentViewController:controller animated:YES completion:NULL];
        } break;
    }
}

@end
