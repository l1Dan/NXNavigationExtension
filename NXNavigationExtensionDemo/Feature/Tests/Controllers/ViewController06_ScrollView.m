//
//  ViewController06_ScrollView.m
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/10/8.
//

#import <objc/runtime.h>
#import <NXNavigationExtension/NXNavigationExtension.h>

#import "ViewController06_ScrollView.h"
#import "UIColor+RandomColor.h"

@interface ViewController06_ScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL disableInteractivePopGesture;
@property (nonatomic, assign) BOOL enableFullscreenInteractivePopGesture;

@end

@implementation ViewController06_ScrollView

- (instancetype)initWithImageNames:(NSArray<NSString *> *)imageNames {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _imageNames = imageNames;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"(UIScrollView)解决手势冲突";
    
    // Step1: if use screen edge pop gesture
//    self.disableInteractivePopGesture = NO;
    self.enableFullscreenInteractivePopGesture = YES;

    [self addViewContent];
    [self addViewConstraints];
    [self setupContent];
}

- (void)addViewContent {
    [self.view addSubview:self.scrollView];
}

- (void)addViewConstraints {
    [self.scrollView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.scrollView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    [self.scrollView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.scrollView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)setupContent {
    if (!self.imageNames || !self.imageNames.count) return;
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    for (NSUInteger index = 0; index < self.imageNames.count; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageNames[index]]];
        imageView.frame = CGRectMake(bounds.size.width * index, 0, bounds.size.width, bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
        [self.scrollView setContentSize:CGSizeMake(bounds.size.width + bounds.size.width * index, bounds.size.height)];
    }
    
    // Step2: if use screen edge pop gesture
//    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.nx_fullscreenPopGestureRecognizer];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) {
        // Step4: if use screen edge pop gesture
//        self.disableInteractivePopGesture = NO;
        self.enableFullscreenInteractivePopGesture = YES;
    } else {
        // Step5: if use screen edge pop gesture
//        self.disableInteractivePopGesture = YES;
        self.enableFullscreenInteractivePopGesture = NO;
    }
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delegate = self;
        
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _scrollView.backgroundColor = [UIColor customColorWithLightModeColor:^UIColor * _Nonnull{
            return [UIColor randomLightColor];
        } darkModeColor:^UIColor * _Nonnull{
            return [UIColor randomLightColor];
        }];
    }
    return _scrollView;
}

- (void)setImageNames:(NSArray<NSString *> *)imageNames {
    _imageNames = imageNames;
    
    if (imageNames) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        for (NSUInteger index = 0; index < imageNames.count; index++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNames[index]]];
            imageView.frame = CGRectMake(bounds.size.width * index, 0, bounds.size.width, bounds.size.height);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.scrollView addSubview:imageView];
            [self.scrollView setContentSize:CGSizeMake(bounds.size.width + bounds.size.width * index, bounds.size.height)];
        }
    }
}

@end
