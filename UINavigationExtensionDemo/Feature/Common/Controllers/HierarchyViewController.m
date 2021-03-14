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
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *chooseViewControllers;
@property (nonatomic, copy) void (^completionHandler)(__kindof UIViewController * _Nullable selectedViewController);

@end

@implementation HierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.tableView];
    
    [self.tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.tableView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    self.widthConstraint = [self.tableView.widthAnchor constraintEqualToConstant:0.0];
    self.widthConstraint.active = YES;

    self.heightConstraint = [self.tableView.heightAnchor constraintEqualToConstant:0.0];
    self.heightConstraint.active = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat height = self.chooseViewControllers.count * ChooseJumpTableViewHeight + 88;
    
    CGFloat maxHeight = MIN(height, size.height - 150.0);
    CGFloat maxWidth = size.width * 0.8;
    self.widthConstraint.constant = maxWidth;
    self.heightConstraint.constant = maxHeight;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    cell.backgroundColor = nil;
    if (indexPath.row < self.chooseViewControllers.count) {
        __kindof UIViewController *viewController = self.chooseViewControllers[indexPath.row];
        cell.textLabel.text = NSStringFromClass([viewController class]);
        cell.textLabel.textColor = [UIColor customTextColor];
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            cell.backgroundColor = [(BaseViewController *)viewController randomColor];
        }
    } else {
        cell.textLabel.text = @"创建新的 UIViewController 实例对象";
        cell.textLabel.textColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return  [UIColor blueColor];
        } darkModeColor:^UIColor * _Nonnull{
            return [[UIColor blueColor] colorWithAlphaComponent:0.5];
        }];
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
    return @"选择需要跳转的视图控制器类型";
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
