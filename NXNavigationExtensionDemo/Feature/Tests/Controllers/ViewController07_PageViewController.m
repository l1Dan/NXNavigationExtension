//
//  ViewController07_PageViewController.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/8.
//

#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController06_ScrollView.h"
#import "ViewController07_PageViewController.h"

@interface ViewController07_PageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray<ViewController06_ScrollView *> *pageViewControllers;

@property (nonatomic, strong) ViewController06_ScrollView *currentViewController;
@property (nonatomic, assign) BOOL disableInteractivePopGesture;
@property (nonatomic, assign) BOOL enableFullscreenInteractivePopGesture;


@end

@implementation ViewController07_PageViewController

- (instancetype)initWithImageNames:(NSArray<NSString *> *)imageNames {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _imageNames = imageNames;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"(UIPageViewController)解决手势冲突";
    
    // Step1: if use screen edge pop gesture
//    self.disableInteractivePopGesture = NO;
    self.enableFullscreenInteractivePopGesture = YES;
    
    for (UIScrollView *subview in self.pageViewController.view.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            // Step2: if use screen edge pop gesture
//            [subview.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
            [subview.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.nx_fullscreenPopGestureRecognizer];
        }
    }
    
    [self setupContent];
}

- (void)setupContent {
    if (!self.imageNames || !self.imageNames.count) return;
    
    NSMutableArray<ViewController06_ScrollView *> *pageViewControllers = [NSMutableArray array];
    for (NSUInteger index = 0; index < self.imageNames.count; index++) {
        [pageViewControllers addObject:[[ViewController06_ScrollView alloc] initWithImageNames:@[self.imageNames[index]]]];
    }
    
    if (!pageViewControllers.count) return;
    
    self.pageViewControllers = [NSArray arrayWithArray:pageViewControllers];
    self.currentViewController = self.pageViewControllers[0];
    
    [self.pageViewController setViewControllers:@[self.currentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self.view addSubview:self.pageViewController.view];
}

- (NSUInteger)indexOfViewController:(__kindof UIViewController *)viewController {
    return [self.pageViewControllers indexOfObject:viewController];
}

#pragma mark -

- (UIColor *)nx_navigationBarBackgroundColor {
    return [UIColor clearColor];
}

- (UIColor *)nx_shadowImageTintColor {
    return [UIColor clearColor];
}

// Step3: if use screen edge pop gesture
//- (BOOL)nx_disableInteractivePopGesture {
//    return self.disableInteractivePopGesture;
//}

- (BOOL)nx_enableFullscreenInteractivePopGesture {
    return self.enableFullscreenInteractivePopGesture;
}

#pragma mark - Getter & Setter

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        UIPageViewControllerTransitionStyle transitionStyle = UIPageViewControllerTransitionStyleScroll;
        UIPageViewControllerNavigationOrientation navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone]};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:transitionStyle navigationOrientation:navigationOrientation options:options];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

- (NSArray<ViewController06_ScrollView *> *)pageViewControllers {
    if (!_pageViewControllers) {
        _pageViewControllers = [NSArray array];
    }
    return _pageViewControllers;
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    
    self.currentViewController = self.pageViewControllers[index];
    return self.currentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == self.pageViewControllers.count) {
        return nil;
    }
    
    self.currentViewController = self.pageViewControllers[index];
    return self.currentViewController;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) return;
    
    // Step4: if use screen edge pop gesture
//    self.disableInteractivePopGesture = !(pageViewController.viewControllers.firstObject == self.pageViewControllers.firstObject);
    self.enableFullscreenInteractivePopGesture = (pageViewController.viewControllers.firstObject == self.pageViewControllers.firstObject);
}

@end
