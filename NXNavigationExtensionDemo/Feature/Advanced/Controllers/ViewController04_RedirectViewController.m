//
//  ViewController04_RedirectViewController.m
//  NXNavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController04_RedirectViewController.h"
#import "ViewController01_Test.h"
#import "ViewController02_Test.h"
#import "ViewController03_Test.h"
#import "ViewController04_Test.h"
#import "ViewController05_Test.h"
#import "HierarchyViewController.h"
#import "RedirectViewControllerModel.h"

#import "UIColor+RandomColor.h"
#import "UITableViewCell+Enabled.h"

@interface ViewController04_RedirectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<RedirectViewControllerModel *> *allModels;

@end

@implementation ViewController04_RedirectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![NSStringFromClass([self class]) isEqualToString:NSStringFromClass([ViewController04_RedirectViewController class])]) {
        self.navigationItem.title = NSStringFromClass([self class]);
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)nx_navigationBarBackgroundColor {
    return self.randomColor;
}

- (UIColor *)nx_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)nx_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [self nx_barTintColor]};
}

- (BOOL)nx_backButtonMenuEnabled {
    return YES;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (NSArray<RedirectViewControllerModel *> *)allModels {
    if (!_allModels) {
        _allModels = @[
            [RedirectViewControllerModel modelWithTitle:NSStringFromClass([ViewController01_Test class]) type:RedirectViewControllerTypeTest1],
            [RedirectViewControllerModel modelWithTitle:NSStringFromClass([ViewController02_Test class]) type:RedirectViewControllerTypeTest2],
            [RedirectViewControllerModel modelWithTitle:NSStringFromClass([ViewController03_Test class]) type:RedirectViewControllerTypeTest3],
            [RedirectViewControllerModel modelWithTitle:NSStringFromClass([ViewController04_Test class]) type:RedirectViewControllerTypeTest4],
            [RedirectViewControllerModel modelWithTitle:NSStringFromClass([ViewController05_Test class]) type:RedirectViewControllerTypeTest5],
            [RedirectViewControllerModel modelWithTitle:@"选择需要跳转的控制器类型" type:RedirectViewControllerTypeChoose],
            [RedirectViewControllerModel modelWithTitle:@"⭐️重定向到：" type:RedirectViewControllerTypeJump],
        ];
    }
    return _allModels;
}

#pragma mark - Private

- (void)setJumpViewControllerCellClickEnabled:(BOOL)enabled {
    for (RedirectViewControllerModel *model in self.allModels) {
        if (model.type == RedirectViewControllerTypeJump) {
            model.clickEnabled = YES;
        } else {
            model.clickEnabled = enabled;
        }
    }
    [self.tableView reloadData];
}

- (void)showChooseJumpViewController {
    __weak typeof(self) weakSelf = self;
    [HierarchyViewController showFromViewController:self
                                withViewControllers:self.navigationController.viewControllers
                                  completionHandler:^(__kindof UIViewController * _Nullable selectedViewController) {
        if (!selectedViewController || ![selectedViewController isKindOfClass:[UIViewController class]]) return;
        // 设置 Cell 不能点击
        [weakSelf setJumpViewControllerCellClickEnabled:NO];
        [weakSelf.navigationController nx_redirectViewControllerClass:[selectedViewController class] initializeStandbyViewControllerBlock:^__kindof UIViewController * _Nonnull{
            UIViewController *vc = [[[selectedViewController class] alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    RedirectViewControllerModel *model = self.allModels[indexPath.row];
    [cell setCellClickEnabled:model.clickEnabled];
    
    cell.backgroundColor = nil;
    cell.textLabel.textColor = [UIColor customTextColor];
    if (model.type == RedirectViewControllerTypeChoose) {
        cell.textLabel.text = model.title;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (model.type == RedirectViewControllerTypeJump) {
        NSArray<__kindof UIViewController *> *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count < 2) {
            cell.textLabel.text = model.title;
        } else {
            __kindof UIViewController *redirectToViewController = viewControllers[viewControllers.count - 2];
            if ([redirectToViewController isKindOfClass:[BaseViewController class]]) {
                cell.backgroundColor = [(BaseViewController *)redirectToViewController randomColor];
            } else {
                cell.backgroundColor = nil;
            }
            NSString *title = redirectToViewController.navigationItem.title ?: NSStringFromClass([redirectToViewController class]);
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", model.title, title];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"点击跳转: %@", model.title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RedirectViewControllerModel *model = self.allModels[indexPath.row];
    if (model.type == RedirectViewControllerTypeChoose) {
        [self showChooseJumpViewController];
    } else if (model.type == RedirectViewControllerTypeJump) {
        // 设置 Cell 不能点击
        [self setJumpViewControllerCellClickEnabled:YES];
        // 如果 selectedViewController ！= nil 就会跳转到对应的视图控制器，反之则返回上一个控制器
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        ViewController04_RedirectViewController *viewController = [[NSClassFromString(model.title) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"功能💉:\n1.自定义跳转到指定控制器类型。\n2.如果跳转的控制器类型不存在则会创建一个新的控制器对象。\n3.目标控制器类型选择好之后可以点击“返回按钮返回”、“手势返回”和点击“⭐️重定向到”，这 3 种方式都可以回到选择类型的所对应的查找到的第一个视图控制器的实例中。\n\n注意⚠️:\n1.控制器类型的查找规则是从栈（ViewControllers）前面往后面查找的，只会判断是否为同一个“类”，而非同一个“实例对象”。查找到则返回对应的“类”，查找不到则创建一个“新的控制器对象实例”。\n2.在不同的导航栏控制器之间不能跳转，只有在同一个导航栏控制器中跳转功能才会生效。";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

@end
