//
//  HierarchyViewController.m
//  UINavigationExtensionDemo
//
//  Created by Leo Lee on 2020/10/30.
//

#import "HierarchyViewController.h"
#import "RandomColorViewController.h"

#import "UIColor+RandomColor.h"

static CGFloat const ChooseJumpTableViewHeight = 44.0;

@interface HierarchyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<__kindof UIViewController *> *chooseViewControllers;
@property (nonatomic, copy) void (^completionHandler)(__kindof UIViewController * _Nullable selectedViewController);

@end

@implementation HierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(nil);
        }
    }];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat height = self.chooseViewControllers.count * ChooseJumpTableViewHeight + 88;
        CGFloat maxHeight = [UIScreen mainScreen].bounds.size.height - 150.0;
        CGFloat finalHeight = MIN(height, maxHeight);
        
        CGRect bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.8, finalHeight);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.bounds = bounds;
        _tableView.center = self.view.center;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Note: + 1 添加一行“创建一个新的 UIViewController”
    return self.chooseViewControllers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row < self.chooseViewControllers.count) {
        __kindof UIViewController *viewController = self.chooseViewControllers[indexPath.row];
        cell.textLabel.text = NSStringFromClass([viewController class]);
        cell.textLabel.textColor = [UIColor customDarkGrayColor];
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            cell.contentView.backgroundColor = [(BaseViewController *)viewController randomColor];
        }
    } else {
        cell.textLabel.text = @"创建一个新的 UIViewController";
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __kindof UIViewController *viewController = [[RandomColorViewController alloc] init];
    if (indexPath.row < self.chooseViewControllers.count) {
        viewController = self.chooseViewControllers[indexPath.row];
    }
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        if (weakSelf.completionHandler) {
            weakSelf.completionHandler(viewController);
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChooseJumpTableViewHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"选择一个控制器跳转";
}

#pragma mark - Public

+ (void)showFromViewController:(__kindof UIViewController *)viewController
           withViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
             completionHandler:(void (^)(__kindof UIViewController * _Nullable selectedViewController))completionHandler {
    HierarchyViewController *vc = [[HierarchyViewController alloc] init];
    vc.chooseViewControllers = viewControllers;
    vc.completionHandler = completionHandler;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:vc animated:NO completion:NULL];
}

@end
