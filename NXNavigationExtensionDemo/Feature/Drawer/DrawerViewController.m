//
//  DrawerViewController.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/10.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "BaseNavigationController.h"
#import "ViewController10_ScrollView.h"
#import "DrawerViewController.h"
#import "UIImage+NavigationBar.h"

@interface DrawerViewController ()

@property (nonatomic, strong) ViewController10_ScrollView *contentViewController;
@property (nonatomic, strong) UIBarButtonItem *closeDrawerButtonItem;

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Drawer 🌈🌈🌈";
    self.navigationItem.rightBarButtonItem = self.closeDrawerButtonItem;
    
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.frame;
    [self.view addSubview:self.contentViewController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // fix; 修复导航栏标题被 contentViewController 修改的问题
    [self nx_setNeedsNavigationBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIImage *)nx_navigationBarBackgroundImage {
    return UIImage.navigationBarBackgroundImage;
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

#pragma mark - Private

- (void)clickCloseDraweButtonItem:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Getter

- (ViewController10_ScrollView *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [[ViewController10_ScrollView alloc] init];
    }
    return _contentViewController;
}

- (UIBarButtonItem *)closeDrawerButtonItem {
    if (!_closeDrawerButtonItem) {
        _closeDrawerButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBarClose"] style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseDraweButtonItem:)];
        _closeDrawerButtonItem.tintColor = [UIColor whiteColor];
    }
    return _closeDrawerButtonItem;
}

@end
