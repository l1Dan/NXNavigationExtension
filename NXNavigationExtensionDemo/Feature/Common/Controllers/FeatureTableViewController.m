//
//  FeatureTableViewController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/9/27.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "FeatureTableViewController.h"
#import "ViewController01_BackgroundColor.h"
#import "ViewController02_BackgroundImage.h"
#import "ViewController03_Transparent.h"
#import "ViewController04_LikeSystemBlurNavigationBar.h"
#import "ViewController05_ShadowColor.h"
#import "ViewController06_ShadowImage.h"
#import "ViewController07_CustomBackButtonImage.h"
#import "ViewController08_CustomBackButton.h"
#import "ViewController09_FullScreen.h"
#import "ViewController10_ScrollView.h"
#import "ViewController11_ScrollViewWithFullScreen.h"
#import "ViewController12_Modal.h"
#import "ViewController13_Blur.h"

#import "ViewController01_DisablePopGesture.h"
#import "ViewController02_FullPopGesture.h"
#import "ViewController03_BackEventIntercept.h"
#import "ViewController04_RedirectViewController.h"
#import "ViewController05_Custom.h"
#import "ViewController06_ClickEventHitToBack.h"
#import "ViewController07_ScrollChangeNavigationBar.h"
#import "ViewController08_WebView.h"
#import "RandomColorViewController.h"

#import "TableViewSection.h"
#import "UIColor+RandomColor.h"
#import "UIDevice+Additions.h"

#import "DrawAnimationTransitionDelegate.h"


@interface FeatureTableViewController () 

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIBarButtonItem *presentDrawerButtonItem;

@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *allViewControllers;
@property (nonatomic, strong) NSArray<TableViewSection *> *sections;
@property (nonatomic, strong) DrawAnimationTransitionDelegate *animationTransitionDelegate;

@end

@implementation FeatureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.presentDrawerButtonItem;
    self.definesPresentationContext = YES;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FeatureTableViewCellIdentifer"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor customDarkGrayColor];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor clearColor];
}

#pragma mark - Private

- (void)clickOpenDraweButtonItem:(UIBarButtonItem *)item {
    [self.animationTransitionDelegate openDrawer];
}

#pragma mark - Getter

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.backgroundImage = [[UIImage alloc] init]; // Remove shadow
        
        if (@available(iOS 13.0, *)) {
            // Nothing...
        } else {
            _searchController.searchBar.backgroundColor = [UIColor customDarkGrayColor];
            _searchController.view.backgroundColor = [UIColor customDarkGrayColor];
        }
    }
    return _searchController;
}

- (UIBarButtonItem *)presentDrawerButtonItem {
    if (!_presentDrawerButtonItem) {
        _presentDrawerButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBarMore"] style:UIBarButtonItemStylePlain target:self action:@selector(clickOpenDraweButtonItem:)];
        _presentDrawerButtonItem.tintColor = [UIColor whiteColor];
    }
    return _presentDrawerButtonItem;
}

- (NSArray<TableViewSection *> *)sections {
    if (!_sections) {
        _sections = [TableViewSection makeAllSections];
    }
    return _sections;
}

- (__kindof UIViewController *)viewControllerForItemType:(TableViewItemType)itemType {
    switch (itemType) {
            // Basic
        case TableViewItemTypeNavigationBarBackgroundColor:
            return [[ViewController01_BackgroundColor alloc] init];
        case TableViewItemTypeNavigationBarBackgroundImage:
            return [[ViewController02_BackgroundImage alloc] init];
        case TableViewItemTypeNavigationBarTransparent:
            return [[ViewController03_Transparent alloc] init];
        case TableViewItemTypeLikeSystemBlurNavigationBar:
            return [[ViewController04_LikeSystemBlurNavigationBar alloc] init];
        case TableViewItemTypeNavigationBarShadowColor:
            return [[ViewController05_ShadowColor alloc] init];
        case TableViewItemTypeNavigationBarShadowImage:
            return [[ViewController06_ShadowImage alloc] init];
        case TableViewItemTypeNavigationBarCustomBackButtonImage:
            return [[ViewController07_CustomBackButtonImage alloc] init];
        case TableViewItemTypeNavigationBarCustomBackButton:
            return [[ViewController08_CustomBackButton alloc] init];
        case TableViewItemTypeNavigationBarFullScreen:
            return [[ViewController09_FullScreen alloc] init];
        case TableViewItemTypeNavigationBarTableViewController:
            return [[ViewController10_ScrollView alloc] init];
        case TableViewItemTypeNavigationBarTableViewControllerWithFullScreen:
            return [[ViewController11_ScrollViewWithFullScreen alloc] init];
        case TableViewItemTypeNavigationBarModal:
            return [[ViewController12_Modal alloc] init];
        case TableViewItemTypeNavigationBarBlur:
            return [[ViewController13_Blur alloc] init];
            // Advanced
        case TableViewItemTypeNavigationBarDisablePopGesture:
            return [[ViewController01_DisablePopGesture alloc] init];
        case TableViewItemTypeNavigationBarFullScreenPopGesture:
            return [[ViewController02_FullPopGesture alloc] init];
        case TableViewItemTypeNavigationBarBackEventIntercept:
            return [[ViewController03_BackEventIntercept alloc] init];
        case TableViewItemTypeNavigationBarRedirectViewController:
            return [[ViewController04_RedirectViewController alloc] init];
        case TableViewItemTypeNavigationBarCustom:
            return [[ViewController05_Custom alloc] init];
        case TableViewItemTypeNavigationBarClickEventHitToBack:
            return [[ViewController06_ClickEventHitToBack alloc] init];
        case TableViewItemTypeNavigationBarScrollChangeNavigationBar:
            return [[ViewController07_ScrollChangeNavigationBar alloc] init];
        case TableViewItemTypeNavigationBarWebView:
            return [[ViewController08_WebView alloc] init];
        case TableViewItemTypeNavigationBarUpdateNavigationBar:
            return [[RandomColorViewController alloc] init];
        case TableViewItemTypeNavigationBarTransitionAnimation: {
            [self.animationTransitionDelegate openDrawer];
        } break;
        default:
            break;
    }
    return nil;
}

- (DrawAnimationTransitionDelegate *)animationTransitionDelegate {
    if (!_animationTransitionDelegate) {
        _animationTransitionDelegate = [[DrawAnimationTransitionDelegate alloc] init];
        [_animationTransitionDelegate setupDrawerWithViewController:self inView:self.view];
    }
    return _animationTransitionDelegate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeatureTableViewCellIdentifer"];
    cell.textLabel.textColor = [UIColor customTextColor];
    TableViewItem *item = self.sections[indexPath.section].items[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%02zd: %@", indexPath.row + 1, item.title];
    cell.accessoryType = item.showsDisclosureIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    TableViewItem *item = self.sections[indexPath.section].items[indexPath.row];
    TableViewItemType itemType = item.itemType;
    __kindof UIViewController *viewController = [self viewControllerForItemType:itemType];
    if (!viewController) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    viewController.title = item.title;
    UINavigationController *controller = [[[self.navigationController class] alloc] initWithRootViewController:viewController];
    if ([viewController isKindOfClass:[ViewController12_Modal class]]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self presentViewController:controller animated:YES completion:NULL];
    } else {
        if (UIDevice.isPhoneDevice) {
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            UINavigationController *detailNavigationController = (UINavigationController *)self.splitViewController.viewControllers.lastObject;
            if (![detailNavigationController.viewControllers.lastObject isMemberOfClass:[viewController class]]) {
                [self showDetailViewController:controller sender:nil];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section].title;
}

@end
