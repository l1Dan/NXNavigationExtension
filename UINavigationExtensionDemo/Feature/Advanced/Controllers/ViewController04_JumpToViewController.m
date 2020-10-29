//
//  ViewController04_JumpToViewController.m
//  UINavigationExtensionDemo
//
//  Created by lidan on 2020/10/27.
//

#import <UINavigationExtension/UINavigationExtension.h>

#import "ViewController04_JumpToViewController.h"
#import "ViewController01_Test.h"
#import "ViewController02_Test.h"
#import "ViewController03_Test.h"
#import "ViewController04_Test.h"
#import "ViewController05_Test.h"
#import "ChooseJumpViewController.h"

typedef NS_ENUM(NSUInteger, JumpViewControllerType) {
    JumpViewControllerTypeTest1,
    JumpViewControllerTypeTest2,
    JumpViewControllerTypeTest3,
    JumpViewControllerTypeTest4,
    JumpViewControllerTypeTest5,
    JumpViewControllerTypeChoose,
    JumpViewControllerTypeJump,
};

@interface ViewController04_JumpToViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSNumber *> *allTypes;

@end

@implementation ViewController04_JumpToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (![NSStringFromClass([self class]) isEqualToString:NSStringFromClass([ViewController04_JumpToViewController class])]) {
        self.navigationItem.title = NSStringFromClass([self class]);
    }
    
    [self.view addSubview:self.tableView];
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
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

- (NSArray<NSNumber *> *)allTypes {
    if (!_allTypes) {
        _allTypes = @[
            @(JumpViewControllerTypeTest1), @(JumpViewControllerTypeTest2), @(JumpViewControllerTypeTest3), @(JumpViewControllerTypeTest4),
            @(JumpViewControllerTypeTest5), @(JumpViewControllerTypeChoose), @(JumpViewControllerTypeJump),
        ];
    }
    return _allTypes;
}

#pragma mark - Private

- (NSString *)titleForType:(JumpViewControllerType)type {
    switch (type) {
        case JumpViewControllerTypeTest1: return [NSString stringWithFormat:@"点击跳转到: %@", NSStringFromClass([ViewController01_Test class])];
        case JumpViewControllerTypeTest2: return [NSString stringWithFormat:@"点击跳转到: %@", NSStringFromClass([ViewController02_Test class])];
        case JumpViewControllerTypeTest3: return [NSString stringWithFormat:@"点击跳转到: %@", NSStringFromClass([ViewController03_Test class])];
        case JumpViewControllerTypeTest4: return [NSString stringWithFormat:@"点击跳转到: %@", NSStringFromClass([ViewController04_Test class])];
        case JumpViewControllerTypeTest5: return [NSString stringWithFormat:@"点击跳转到: %@", NSStringFromClass([ViewController05_Test class])];
        case JumpViewControllerTypeChoose: return @"选择需要跳转的目标控制器";
        case JumpViewControllerTypeJump: return @"跳转到目标控制器";
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    JumpViewControllerType type = self.allTypes[indexPath.row].unsignedIntegerValue;
    cell.textLabel.text = [self titleForType:type];
    if (type == JumpViewControllerTypeChoose || type == JumpViewControllerTypeJump) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JumpViewControllerType type = self.allTypes[indexPath.row].unsignedIntegerValue;
    if (type == JumpViewControllerTypeChoose) {
        __weak typeof(self) weakSelf = self;
        [ChooseJumpViewController showViewControllerFromViewController:self withViewControllers:self.navigationController.viewControllers completionHandler:^(__kindof UIViewController * _Nullable selectedViewController) {
            if (!selectedViewController || ![selectedViewController isKindOfClass:[UIViewController class]]) return;
        
            [weakSelf.navigationController ue_jumpViewControllerClass:[selectedViewController class] usingCreateViewControllerHandler:^__kindof UIViewController * _Nonnull{
                return [[[selectedViewController class] alloc] init];
            }];
        }];
    } else if (type == JumpViewControllerTypeJump) {
        // 如果 selectedViewController ！= nil 就会跳转到对应的视图控制器，反之则返回上一个控制器
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *className = [[cell.textLabel.text componentsSeparatedByString:@": "] lastObject];
        if (className) {
            ViewController04_JumpToViewController *viewController = [[NSClassFromString(className) alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"功能💉:\n1.自定义跳转到指定目标控制器。\n2.跳转的目标控制器如果不存在则创建一个新的控制器。\n3.目标控制器选择好之后可以点击返回、手势返回和点击按钮跳转 3 种方式都可以回到目标控制器。\n\n注意⚠️:\n1.控制器查找规则是从栈（ViewControllers）前面往后面查找的，只会判断是否为同一个“类”，而非同一个“实例对象”，查找到则返回对应的“类”，查找不到则创建一个“新的控制器对象实例”。\n2.在不同的导航栏控制器之间不能跳转，只有在同一个导航栏控制器中跳转功能才会生效。";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

@end
