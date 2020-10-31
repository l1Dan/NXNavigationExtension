//
//  ViewController04_JumpToViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/27.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController04_JumpToViewController.h"
#import "ViewController01_Test.h"
#import "ViewController02_Test.h"
#import "ViewController03_Test.h"
#import "ViewController04_Test.h"
#import "ViewController05_Test.h"
#import "HierarchyViewController.h"
#import "JumpViewControllerModel.h"

#import "UITableViewCell+Enabled.h"

@interface ViewController04_JumpToViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JumpViewControllerModel *> *allModels;

@end

@implementation ViewController04_JumpToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (![NSStringFromClass([self class]) isEqualToString:NSStringFromClass([ViewController04_JumpToViewController class])]) {
        self.navigationItem.title = NSStringFromClass([self class]);
    }
    
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIColor *)ue_navigationBarBackgroundColor {
    return self.randomColor;
}

- (UIColor *)ue_barTintColor {
    return [UIColor whiteColor];
}

- (NSDictionary<NSAttributedStringKey,id> *)ue_titleTextAttributes {
    return @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (NSArray<JumpViewControllerModel *> *)allModels {
    if (!_allModels) {
        _allModels = @[
            [JumpViewControllerModel modelWithTitle:NSStringFromClass([ViewController01_Test class]) type:JumpViewControllerTypeTest1],
            [JumpViewControllerModel modelWithTitle:NSStringFromClass([ViewController02_Test class]) type:JumpViewControllerTypeTest2],
            [JumpViewControllerModel modelWithTitle:NSStringFromClass([ViewController03_Test class]) type:JumpViewControllerTypeTest3],
            [JumpViewControllerModel modelWithTitle:NSStringFromClass([ViewController04_Test class]) type:JumpViewControllerTypeTest4],
            [JumpViewControllerModel modelWithTitle:NSStringFromClass([ViewController05_Test class]) type:JumpViewControllerTypeTest5],
            [JumpViewControllerModel modelWithTitle:@"选择需要跳转的目标控制器" type:JumpViewControllerTypeChoose],
            [JumpViewControllerModel modelWithTitle:@"跳转到目标控制器" type:JumpViewControllerTypeJump],
        ];
    }
    return _allModels;
}

#pragma mark - Private

- (void)setJumpViewControllerCellClickEnabled:(BOOL)enabled {
    for (JumpViewControllerModel *model in self.allModels) {
        if (model.type == JumpViewControllerTypeJump) {
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
        [weakSelf.navigationController ue_jumpViewControllerClass:[selectedViewController class]
                                 usingCreateViewControllerHandler:^__kindof UIViewController * _Nonnull {
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
    
    JumpViewControllerModel *model = self.allModels[indexPath.row];
    [cell setCellClickEnabled:model.clickEnabled];
    
    if (model.type == JumpViewControllerTypeChoose || model.type == JumpViewControllerTypeJump) {
        cell.textLabel.text = model.title;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"点击跳转到: %@", model.title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JumpViewControllerModel *model = self.allModels[indexPath.row];
    if (model.type == JumpViewControllerTypeChoose) {
        [self showChooseJumpViewController];
    } else if (model.type == JumpViewControllerTypeJump) {
        // 设置 Cell 不能点击
        [self setJumpViewControllerCellClickEnabled:YES];
        // 如果 selectedViewController ！= nil 就会跳转到对应的视图控制器，反之则返回上一个控制器
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        ViewController04_JumpToViewController *viewController = [[NSClassFromString(model.title) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"功能💉:\n1.自定义跳转到指定目标控制器。\n2.跳转的目标控制器如果不存在则创建一个新的控制器。\n3.目标控制器选择好之后可以点击返回、手势返回和点击按钮跳转 3 种方式都可以回到目标控制器。\n\n注意⚠️:\n1.控制器查找规则是从栈（ViewControllers）前面往后面查找的，只会判断是否为同一个“类”，而非同一个“实例对象”，查找到则返回对应的“类”，查找不到则创建一个“新的控制器对象实例”。\n2.在不同的导航栏控制器之间不能跳转，只有在同一个导航栏控制器中跳转功能才会生效。";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

@end
